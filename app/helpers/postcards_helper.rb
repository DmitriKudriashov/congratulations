module PostcardsHelper

  def postcard_image(postcard)

    path_postcard_files = "#{Rails.root}/app/assets/images/" #/public/upload/"
    if postcard.filename.present? && File.file?("#{path_postcard_files}#{postcard.filename}")
      fileimage = postcard.filename
    else
      fileimage = "" #File.file?("#{path_postcard_files}/award.png") ? 'award.png' : 'Without Postcard Image!'
    end
    # byebug
    image_tag(fileimage, size: "170x110")
  end

  def upload(uploaded_file) # uploaded_file =>  params[:picture]
    File.open(Rails.root.join('public', 'uploads', uploaded_file.original_filename), 'wb') do |file|
      file.write(uploaded_file.read)
    end
  end

end
