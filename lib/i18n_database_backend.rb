class I18nDatabaseBackend < I18n::Backend::KeyValue
  include I18n::Backend::Pluralization

  def initialize
    super(I18nDatabaseStorage.new, false)
  end

  def reload!
    @store.reload!
  end

  def available_locales
    Language.published_names.map(&:to_sym)
  end

  protected

  def lookup(locale, key, scope = [], options = {})
    key   = normalize_flat_keys(locale, key, scope, options[:separator])
    value = @store["#{locale}.#{key}"]
  end

  def pluralizer(locale)
    puts locale
    lambda {|count| count == 1 ? :one : :other }
  end

  class I18nDatabaseStorage
    def [](key)
      @translations[key]
    end

    def []=(key, value)
    end

    def keys
      @translations.keys
    end

    def reload!
      if Translation.table_exists?
        @translations = Translation.as_translations
      end
    end
  end
end
