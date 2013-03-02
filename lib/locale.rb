class Locale < Struct.new(:code)
  ENGLISH_LOCALE_CODE = :en

  class << self
    def current
      new(I18n.locale)
    end

    def all
      I18n.available_locales.map do |l|
        new(l)
      end
    end

    def non_english
      all.reject(&:english?)
    end

    def find_by_language_name(native_language_name)
      all.find { |l| l.native_language_name == native_language_name }
    end

    def find_by_code(code)
      all.find { |l| l.code == code.to_sym }
    end
  end

  def english?
    code.to_sym == ENGLISH_LOCALE_CODE
  end

  def native_language_name
    I18n.t("language_names.#{code}", locale: code)
  end

  def english_language_name
    I18n.t("language_names.#{code}", locale: ENGLISH_LOCALE_CODE)
  end

  def rtl?
    I18n.t("i18n.direction", locale: code, default: "ltr") == "rtl"
  end

  def to_param
    code.to_s
  end
end

