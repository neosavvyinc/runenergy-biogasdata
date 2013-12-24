# Cross-Domain AJAX for IE8

Implements automatic *Cross Origin Resource Sharing* support using the `XDomainRequest` object for IE8 and IE9 when using the [$.ajax](http://api.jquery.com/jQuery.ajax/) function in jQuery 1.5+.
> **CORS** requires the `Access-Control-Allow-Origin` header to be present in the AJAX response from the server.

In order to use `XDomainRequest` in Internet Explorer, the request must be:
- Only GET or POST
 - When POSTing, the data will always be sent with a `Content-Type` of `text/plain`
- Only HTTP or HTTPS
 - Protocol must be the same scheme as the calling page
- Always asynchronous

Working example here:
http://jsfiddle.net/MoonScript/Q7bVG/show/

## Instructions

With at least jQuery version 1.5, just include the [jquery.xdomainrequest.min.js](http://cdnjs.cloudflare.com/ajax/libs/jquery-ajaxtransport-xdomainrequest/1.0.1/jquery.xdomainrequest.min.js) script into your page, then make your AJAX call like you normally would:

```JavaScript
$.ajax({
  url: 'http://jsonmoon.jsapp.us/',
  dataType: 'json'
}).done(function(data){
  console.log(data.name.first);
});
```

## CDN

This script is hosted by [CDNJS](http://cdnjs.com):

http://cdnjs.cloudflare.com/ajax/libs/jquery-ajaxtransport-xdomainrequest/1.0.1/jquery.xdomainrequest.min.js
