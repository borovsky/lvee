class I18nDatabaseBackend < I18n::Backend::KeyValue
  def initialize
    super(I18nDatabaseStorage.new, false)
  end

  def reload!
    @store.reload!
  end

  protected

  def lookup(locale, key, scope = [], options = {})
    key   = normalize_flat_keys(locale, key, scope, options[:separator])
    value = @store["#{locale}.#{key}"]
  end

  class I18nDatabaseStorage
    def [](key)
      @translations[key]
    end

    def []=(key, value)
    end

    def reload!
      if Translation.table_exists?
        ts = {}
        Translation.all.each{|t| ts[t.full_key] = t.value}
        @translations = ts
      end
    end
  end
end
