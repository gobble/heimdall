module Heimdall
  module Utils

    class LobResponse

      attr_accessor :primary_line, :secondary_line, :deliverability, :city,
                    :state, :zip_code, :address_type, :primary_number,
                    :street_predirection, :street_name, :street_suffix,
                    :street_postdirection

      def initialize(params = {})
        params.each { |attr, value| public_send("#{attr}=", value) }
      end

      def commercial?
        address_type == "commercial"
      end

      def primary_field
        primary_line_components.
          map { |component| send(component).to_s }.
          reject(&:empty?).
          join(" ")
      end

      class << self
        def build(lob_response)
          params = retrieve_params(lob_response.symbolize_keys)
          new(params)
        end

        private

        def retrieve_params(lob_response)
          components = lob_response.dig(:components)
          lob_response.
            slice(:primary_line, :secondary_line, :deliverability).
            merge(components.slice(*components_attributes))
        end

        def components_attributes
          %w(
            city state zip_code address_type primary_number street_predirection
            street_name street_suffix street_postdirection
          )
        end
      end

      private

      def primary_line_components
        %w(
          primary_number street_predirection street_name street_suffix
          street_postdirection
        )
      end

    end
  end
end
