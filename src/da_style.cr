

module DA_STYLE
  macro file_read!(dir, raw)
    File.read(
      File.expand_path(
        File.join({{dir}}, {{raw}}.gsub(/\.+/, ".").gsub(/[^a-z0-9\/\_\-\.]+/, "_"))
      )
    )
  end # === macro file_read!
end # === module DA_STYLE

{% if env("DEV_BUILD") %}
  macro inspect!(*args)
    puts \{{*args}}
  end
{% end %}

