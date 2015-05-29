require "log-plot/version"
require 'open3'
require 'date'

module LogPlot
  class Application
    def initialize(input, options)
      @input = input
      @options = options
      @offset = options[:period]
      @output_file = options[:output]
      @log_type = options[:log_type]
    end

    def run
      plot(gnuplot_commands(build_data))
    end

    def build_data
      data = []
      count = 0
      ts_upper = nil

      while lines = @input.gets
        lines.each_line do |line|
          begin
            case @log_type
            when :access
              datetime_pattern = / \[([0-9]{2}\/[a-zA-Z]{3}\/[0-9]{4}:[0-9]{2}:[0-9]{2}:[0-9]{2} [+-][0-9]{4})/
              datetime_str = datetime_pattern.match(line).captures[0]
              line_dt = DateTime.strptime(datetime_str, '%d/%b/%Y:%H:%M:%S %z')
            when :error
              # nginx error log regex /^(?<time>[^ ]+ [^ ]+) \[(?<log_level>.*)\] (?<pid>\d*).(?<tid>[^:]*): (?<message>.*)$/
              datetime_pattern = /^([0-9]{4}\/[0-9]{2}\/[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}) /
              datetime_str = datetime_pattern.match(line).captures[0]
              line_dt = DateTime.strptime(datetime_str, '%Y/%m/%d %H:%M:%S')
            end
            date = line_dt.strftime('%Y-%m-%d')
            time = line_dt.strftime('%H:%M:%S')
            ts = line_dt.strftime('%s').to_i

            if ts_upper.nil?
              ts_upper = ts + @offset
            end

            if ts < ts_upper
              count += 1
            else
              data << [date, time, count]
              ts_upper = ts + @offset
              count = 1
            end
          rescue Errno::EPIPE
            exit 74
          rescue
            $stderr.puts "log-plot: invalid log format for #{@log_type} log type"
            exit 1
          end
        end
      end

      data
    end

    def gnuplot_commands(data)
      if @offset > 60
        y_axis_value = @offset / 60
        y_axis_unit = "minutes"
      elsif @offset == 60
        y_axis_unit = "minute"
      else
        y_axis_value = @offset
        y_axis_unit = "seconds"
      end
      y_axis_value_and_unit = "#{y_axis_value} #{y_axis_unit}"
      y_axis_value_and_unit = y_axis_value_and_unit.strip unless y_axis_value

      case @log_type
      when :access
        type = "Requests"
      when :error
        type = "Errors"
      end

      if data.count > 0
        gnuplot_commands = <<-EOF
          reset
          set xdata time
          set timefmt "%Y-%m-%d %H:%M:%S"
          set format x "%H:%M"
          set autoscale
          set ytics
          set grid y
          set auto y
          set term png truecolor
          set output "#{@output_file}"
          set xlabel "Time"
          set ylabel "#{type} per #{y_axis_value_and_unit}"
          set grid
          set boxwidth 0.95 relative
          set style fill transparent solid 0.5 noborder
          plot "-" using 1:3 w boxes lc rgb "green" notitle
        EOF

        data.each do |row|
          gnuplot_commands << row[0].to_s + " " + row[1].to_s + " " + row[2].to_s + "\n"
        end
        gnuplot_commands << "e\n"
      end

      gnuplot_commands
    end

    def plot(commands)
      if commands.nil?
        $stderr.puts "log-plot: no data"
        exit 1
      else
        image, s = Open3.capture2(
          "gnuplot",
          :stdin_data => commands,
          :binmode=>true
        )
      end
    end
  end
end

