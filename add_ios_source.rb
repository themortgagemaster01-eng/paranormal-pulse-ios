require 'xcodeproj'
project_path = 'ios/App/App.xcodeproj'
project = Xcodeproj::Project.open(project_path)
target  = project.targets.find { |t| t.name == 'App' }
group   = project.main_group['App']['App'] || project.main_group['App']
%w[MagnetometerPlugin.swift MagnetometerPlugin.m].each do |fname|
  path = "ios/App/App/#{fname}"
  next unless File.exist?(path)
  unless group.files.any? { |f| f.display_name == fname }
    ref = group.new_reference(fname)
    target.add_file_references([ref]) if fname.end_with?('.swift', '.m')
    puts "Added #{fname} to App target"
  end
end
project.save
