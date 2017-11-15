

module DA_CSS
  macro file_read!(dir, raw)
    File.read(
      File.expand_path(
        File.join({{dir}}, {{raw}}.gsub(/\.+/, ".").gsub(/[^a-z0-9\/\_\-\.]+/, "_"))
      )
    )
  end # === macro file_read!
end # === module DA_CSS

require "./da_css/printer"

{% if env("DEV_BUILD") %}
  macro inspect!(*args)
    puts \{{*args}}
  end
{% end %}

