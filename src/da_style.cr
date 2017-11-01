

module DA_STYLE

end # === module DA_STYLE

{% if env("DEV_BUILD") %}
  macro inspect!(*args)
    puts \{{*args}}
  end
{% end %}

