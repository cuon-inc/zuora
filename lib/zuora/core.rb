module Zuora
  module Core
    class RecordNotFound < StandardError; end

    class RecordInvalid < StandardError; end

    # @return [Hash]
    def self.find(object_name, id)
      raise RecordNotFound, "Couldn't find #{id}" if id.blank?

      res = "Zuora::Api::V1::#{object_name.camelize}".constantize.retrieve(id)

      # rubocop:disable Style/GuardClause
      if res["success"] || res["Id"].present? # Contactの場合successがないのでIdの存在チェック
        res
      else
        raise RecordNotFound, "Couldn't find #{id}"
      end
      # rubocop:enable Style/GuardClause
    end

    # @return [Hash]
    def self.find_by(object_name, **args)
      conditions = args.map do |key, value|
        if value.is_a?(String)
          "#{key} = '#{value}'"
        elsif value.nil?
          "#{key} = null"
        else
          "#{key} = #{value}"
        end
      end
      conditions = conditions.join(" AND ")
      query = <<-QUERY.squish
        select Id
        from #{object_name}
        where #{conditions}
      QUERY

      data = Zuora::Api::V1::Action.query(query)

      record = data["records"]&.first || {}
      begin
        find(object_name, record["Id"])
      rescue RecordNotFound
        nil
      end
    end

    def self.create!(object_name, params, id_key_name)
      res = "Zuora::Api::V1::#{object_name.camelize}".constantize.create(params)

      if success?(res)
        config.logger.debug { "[Zuora][#{object_name}] Create by: #{res[id_key_name]}" }
        find(object_name, res[id_key_name])
      else
        config.logger.error "[Zuora][#{object_name}] Cound't create"

        raise RecordInvalid, errors(res)
      end
    end

    def self.update!(object_name, id, params)
      res = "Zuora::Api::V1::#{object_name.camelize}".constantize.update(id, params)

      if success?(res)
        config.logger.debug { "[Zuora][#{object_name}] Update by: #{id}" }
        find(object_name, id)
      else
        config.logger.error "[Zuora][#{object_name}] Cound't update"

        raise RecordInvalid, errors(res)
      end
    end

    def self.config
      ::Zuora.config
    end

    def self.success?(res)
      res["success"] || res["Success"]
    end

    def self.errors(res)
      (res["reasons"] || res["Errors"]).map do |error|
        error_message(error)
      end
    end

    def self.error_message(error)
      error["message"] || error["Message"]
    end

    private_class_method :success?, :errors, :error_message
  end
end
