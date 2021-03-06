sinic
=====

Sinatra API for nicEdit.js Image Upload (Embed in Rails)

SINIC is a very basic Sinatra upload target for the image uploader in nicEdit.js.

SINIC came about because I needed to use nicEdit.js inside a Rails app and have the ability to upload and inline images into nicEdit enabled Text Areas. The default nicEdit uploader is pointed at imgur.com and, although a separate PHP uploader is provided, I did not want either (a) to upload my images to imgur or (b) to have to run a PHP page inside or alongside my Rails app. After much searching, and failing to find anything useful, I decided to write my own basic image uploader that complies with the return types that nicEdit.js expects.

SINIC is therefore intended to be embedded as an API inside a Rails app - which is what this README discusses. You could, of course, always take this and use it in a Sinatra-only app.

Fundamentally, SINIC is really just a snippet you should take on and adapt to suit your own needs. I stress that the code here does not contain any security (over and above checking the key param - which is the standard key value contained in nicEdit.js) and thus you should implement your own controls as you see fit.

I'd also stress that, because of the way I wanted this to work (i.e.: uploading the file and immediately putting it inline in the nicEdit enabled Text Area), SINIC does not check to see if a file exists before uploading. You have been warned….

As far as licensing is concerned: there isn't one. Take this if you need it and enjoy. :)

How to use:

1. Have a Rails app handy.

2. Download nicEdit.js from http://nicedit.com/ - make sure to select the optional nicUpload plugin - and place in your Asset Pipeline (or from wherever you are serving JS to your app). SINIC written against nicEdit Version 0.9 r24 of 07JUN12.

  NB: If you put nicEdit.js in the asset pipeline, you will need to edit nicEdit.js and change the location for iconsPath to something like '/assets/nicEditorIcons.gif' (making sure you actually put the GIF file in the place you state!).

3. In the view(s) you want to use nicEdit in, add the relevant JavaScript to nicEdit-enable one or more text areas.

4. Probably a good idea to check that all this works now - before you start adding SINIC. If you run up your app, and go to the nicEdit-enabled view, you should see your text area(s) turned into WYSIWYG editors and have an 'Upload Image' button. This is the button that SINIC makes useful (if you don't want to use imgur or have a separate PHP server to support image uploads).

5. In your Gemfile, add required gems:

	gem 'sinatra' (SINIC was tested with Sinatra 1.3.3 and dependencies).
	gem 'mini_magick' (SINIC was tested with MiniMagick 3.4 - mainly because I was using CarrierWave for uploads elsewhere in the app. This is only used for getting image height and width so you can ignore it but then you have to amend SINIC to use an alternative height and width finding method).

6. Put SINIC's application.rb in <APP_ROOT>/lib/api

7. In your routes.rb, add the following:

	require 'api/application' <- At the top, before routes.draw do

	mount Api::Application, :at => "/api" <- At the top, after routes.draw do

	NB: The effect of these additions is to make the handlers in the SINIC application.rb available at <YOUR_APP_URL>/api

	(And, yes, you can extend the SINIC application.rb to provide additional API functions if you wish. Just break out your trusty Sinatra guide!)

8. Edit nicEdit.js. If you downloaded the base package plus only the nicUpload plugin, you should find that the last line starts var nicUploadButton = <blah>. In the <blah>, change the nicURI entry to:- nicURI:"/api/upload"

9. Make sure you have an accessible folder tree under <YOUR_APP>/public that matches the one declared in SINIC for uploads. In the code here, that's /uploads/nimgs/

10. Fire it up and make sure it's all working. Then, enjoy WYSIWYG editing with inline images as stored on your own app server.


David.
