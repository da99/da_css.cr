
da\_css.cr
============

The idea is to let users use a subset of CSS
to upload their own CSS files
while preventing CSS security vulnerabilities.


Security links:
===============
* http://www.diaryofaninja.com/blog/2013/10/30/executing-javascript-inside-css-another-reason-to-whitelist-and-encode-user-input
* https://www.curesec.com/blog/article/blog/Reading-Data-via-CSS-Injection-180.html
* Guidelines:
  * Don't allow resources to outside the site: url('http://...my.image.png')
    * Can be used to track people and spread harmful code.

Example:
=======

Let's have a String filled with this content:

```Crystal
blocks = DA_CSS.parse(%[ div { border: 1px solid red; } ])

blocks.each { |blok|
  blok.selectors # Deque(DA_CSS::Selectors
  blok.propertys # Deque(Color_Keyword | Color | A_String | A_Number | ...)

  width = blok.propertys.first.values.first
  case width
  when DA_CSS::Number_Unit
    width.a_number.to_number == 1
    width.unit.token.to_s == "px"
  end
}
```
