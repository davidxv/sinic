module Api
	class Application < Sinatra::Base

		# This contains a simple base set of API handlers.
		# You can extend this - to give more API functions in your Rails app - using standard Sinatra practices
		# Bear in mind this is an embedded API - you get access to all entities in your Rails app without
		# having to explicitly link them in. If nothing else, this makes life easier in providing an API! :)

		not_found do
			redirect to('/')
		end

		error do
			redirect to('/')
		end

		error 404 do
			redirect to('/')
		end

		get '/' do
			"Hello from the API! Nothing to see here!!"
		end

		post '/upload' do

			# Note, this is the only 'security' employed. It's the default key set in nicEdit.js
			# If you want more security here, roll your own!
			if params[:key] == 'b7ea18a4ecbda8e92203fa4968d10660'
			
				urlToNewImage = '/uploads/nimgs/' + params['image'][:filename]

				File.open(Rails.public_path + urlToNewImage, "wb") do |f|
					f.write(params['image'][:tempfile].read)
				end

				# Open up the image file
				# If you don't want to use MiniMagick, find another way of finding image height and width
				# or simply set standard dimensions - but risk the attendant distortion in nicEdit!
				imageFile = MiniMagick::Image.open(Rails.public_path + urlToNewImage)

				# Structure JSON reponse - per IMGUR.COM JSON response - here
				# Yes, using two structures when we could use one but this is clearer if you are not familiar with
				# seeing JSON structures being built in ruby.
				dataJSON = {
					:id => "nimg",
					:links => {:original => urlToNewImage},
					:image => {:width => imageFile[:width], :height => imageFile[:height]}
				}

				imgurResponse = {
					:upload => dataJSON,
					:success => true,
					:status => 200
				}

				return imgurResponse.to_json
			else
				# Return 404 if key is invalid - lets not give any clues that there's an auth mechanism here. :)
				error 404
			end
		end
	end
end
