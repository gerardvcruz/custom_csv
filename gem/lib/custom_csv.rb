module CustomCSV
  class Generator
    def generate_csv(model, options)
      @csv = "" # the csv, yay!
      @model = model.classify.constantize # convert model arg to Class

      # does the model exist
      if @model.exists?
        add_csv_headers options

        unless options.empty?
          @model.all.each do |model_object|
            @headers.all.each do |header|
              @csv << "\"#{model_object.send(header).to_s}\","
              !(header == @arr[-1]) ? @csv << "," : @csv << "\n"
            end
          end
        end

        @csv
      else
        raise "#{@model} doesn't exist!"
      end
    end

    private
      def add_model_headers options
        # load ALL the model column names!
        @headers = @model.column_names

        unless options.empty?
          includes = options[:includes]
          excludes = options[:excludes]

          unless excludes.empty?
            @headers.delete_if { |header| excludes.include? header }
          end

          unless includes.empty?
            unless includes[:parent].empty?
              includes[:parent].each do |parent|
                if @model.try(parent).nil?
                  raise "No relationship found: #{@model}.#{parent}"
                else
                  @headers.insert 0, parent
                end
              end
            end

            unless includes[:child].empty?
              includes[:child].each do |child|
                if @model
                  .try(child.pluralized == child ? child : child.pluralized)
                  .nil?

                  raise "No relationship found: #{@model}.#{child}"
                else
                  @headers << child
                end
              end
            end
          end
        end

        @headers.each do |column_header|
          @csv << "\"#{column_header.capitalize.gsub("_", " ")}\""
          !(column_header == @arr[-1]) ? @csv << "," : @csv << "\n"
        end
      end

  end
end
