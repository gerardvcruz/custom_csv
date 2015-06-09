def generate_csv(model, filters, options)
  @csv = ""
  @model = model.classify.constantize

  @model.all.each do |model_object|
    if options.nil?
      # by default, load all params from database
      @headers = @model.column_names
      @headers.each do |column_header|
        if !(column_header == @arr[-1])
          @csv << "\"#{column_header.capitalize.gsub("_", " ")}\","
        else
          @csv << "\"#{column_header.capitalize.gsub("_", " ")}\"\n"
        end
      end

      @model.all.each do |model_object|
        if !(element == @arr[-1])
          @csv << "\"#{model_object.send(element).to_s}\","
        else
          @csv << "\"#{model_object.send(element).to_s}\"\n"
        end
      end

    else
      @headers = options
      @headers.each do |column_header|
        if !(column_header == @arr[-1])
          @csv << "\"#{column_header.capitalize.gsub("_", " ")}\","
        else
          @csv << "\"#{column_header.capitalize.gsub("_", " ")}\"\n"
        end
      end


      @model.all.each do |model_object|
        @headers.each do |column_header|
          # uses markers such as ":" and "%" to check if
          # user wants to retrieve data from external model

          # ":" (colon) signifies parent model
          if column_header.include?(":")
            parent_model = column_header.partition(':').first
            parent_column = column_header.partition(':').third

            parent_model = parent_model.classify.constantize
            @csv << "\"#{parent_model.first.send(parent_column).to_s}\","

          # "%" (percent) signifies child model
          elsif column_header.include?("%")
            child_model = column_header.partition('%').first
            child_column = column_header.partition('%').third

            child_model = child_model.classify.constantize
            @csv << "\"#{child_model.first.send(child_column).to_s}\","

          else
            @csv << "\"#{model_object.send(column_header).to_s}\","
          end
        end
      end
    end

    @csv
  end
end
