# modify_devise_controllers.rb

require 'fileutils'

# Specify the root directory of your app
root_dir = 'app/controllers'

# Traverse the directories
Dir.glob("#{root_dir}/**/devise/*.rb").each do |file_path|
  file_name = File.basename(file_path)

  # Open the file and read its content
  file_content = File.read(file_path)

  # Match the pattern for class definition (e.g. `class Admin::UnlocksController`)
  class_pattern = /^class (\w+)::(\w+)Controller < Devise::\w+Controller/

  # Check if class name needs modification
  if file_content =~ class_pattern && !file_content.include?("#{Regexp.last_match(1)}::Devise")
    # Get the route group name (e.g., Admin) and the controller name (e.g., Unlocks)
    route_group = Regexp.last_match(1)
    controller_name = Regexp.last_match(2)

    # Modify the class definition to add `Devise::` between the route group and controller name
    new_class_name = "class #{route_group}::Devise::#{controller_name}Controller < Devise::#{controller_name}Controller"

    # Replace the old class definition with the new one
    updated_content = file_content.sub(class_pattern, new_class_name)

    # Write the updated content back to the file
    File.write(file_path, updated_content)

    puts "Updated: #{file_path}"
  else
    puts "No modification needed for: #{file_path}"
  end
end

puts "All applicable files have been modified."
