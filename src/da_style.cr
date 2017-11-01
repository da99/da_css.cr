

module DA_STYLE
  macro file_read!(raw, dir)
    File.read(File.expand_path({{raw}}.gsub(/\.+/, ".").gsub(/[^a-z0-9\/\_\-\.]+/, "_"), {{dir}}))
  end # === macro file_read!
end # === module DA_STYLE

{% if env("DEV_BUILD") %}
  macro inspect!(*args)
    puts \{{*args}}
  end
{% end %}

