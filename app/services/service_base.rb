# frozen_string_literal: true

module ServiceBase
  extend ActiveSupport::Concern

  included do
    def self.call(**args)
      new(**args).call
    end
  end

  class Success
    attr_reader :object

    def initialize(object)
      @object = object
    end

    def success?
      true
    end

    def failure?
      false
    end
  end

  class Failure
    attr_reader :object, :errors

    def initialize(object, errors)
      @object = object
      @errors = errors
    end

    def success?
      false
    end

    def failure?
      true
    end
  end
end
