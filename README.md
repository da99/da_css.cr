
da\_css.cr
============

The idea is to let users use a subset of CSS
to upload their own CSS files
while preventing CSS security vulnerabilities.


Security links:
===============
* http://www.diaryofaninja.com/blog/2013/10/30/executing-javascript-inside-css-another-reason-to-whitelist-and-encode-user-input
* https://www.curesec.com/blog/article/blog/Reading-Data-via-CSS-Injection-180.html


Example:
=======

File `input.css`:

```css
  /* Setup vars: */
  div { background-color: #fff; }

  .empty {
    border-radius(10px, 20px);
    background { color: #000; }
    font { size: 1em; }
    font-size: 2em;
  }

  body {
    padding: 20px 0 0 10em;
    background {
      color: #fcf;
      repeat: no-repeat;
    }
  }
```

Output:

```css
  div {
    background-color: #FFF;
  }
  .empty {
    -webkit-border-radius: 10px;
    border-radius: 20px;
    background-color: #000;
    font-size: 1em;
    font-size: 2em;
  }
  body {
    padding: 20px 0 0 10em;
    background-color: #000;
    background-repeat: no-repeat;
    background-color: #0000011;
  }
```
