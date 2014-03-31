#The BIM-Reporter adds ifc_classes_in_model and classes_attributes methods into ajax.rb

def ifc_classes_in_model
	class_arr=["IfcProject","IfcSite","IfcBuilding","IfcBuildingStorey","IfcSpace","IfcWall","IfcSlab","IfcColumn","IfcBeam","IfcDoor","IfcWindow","IfcStair"]
	puts $cgi.header
    require File.dirname(__FILE__) + '/extensions/Server.rb'
	Server.classes_list $cgi['f']
	class_arr.each { |k|
	puts "<option value='" + k.upcase + "'>" +  k.to_s.sub("Ifc","") + ":" + $list_of_objects[k].to_s + "</option>" if $list_of_objects[k] != nil
	}
	$list_of_objects.each { |k,v|
	next if k == "IFC" or class_arr.include?(k)	
	puts "<option value='" + k.upcase + "'>" +  k.to_s.sub("Ifc","") + ":" + v.to_s + "</option>"
	}
end

def classes_attributes
	puts $cgi.header
	att_arr=["initialize1","to_PSF21","attach_to_obj","to_dae","to_dae_geometry","to_dae_node","cache","attach"]
	cls = Kernel.const_get($cgi['c'].to_s)	
	puts "<optgroup label='Class attributes'>"
	cls.nonInverseAttributes.split("|").each { |att|
	next if att == ""
	att_arr << att.to_s
	puts "<option value='" + att + "'>" + att.to_s + "</option>"
	}
	puts "</optgroup>"
	puts "<optgroup label='IFC-attributes'>"
	puts "<option value='self.class'>Class name</option>"
	puts "<option value='line_id'>IFC-ID</option>"
	puts "</optgroup>"
	puts "<optgroup label='Inverse attributes'>"
	cls.inverseAttributes.split("|").each { |att|
	next if att == ""
	att_arr << att.to_s
	puts "<option value='" + att + "'>" + att.to_s + "</option>"
	}
	puts "</optgroup>"	
	puts "<optgroup label='Derived Attributes'>"
	cls.derivAttributes.split("|").each { |att|
	next if att == ""
	att_arr << att.to_s
	puts "<option value='" + att + "'>" + att.to_s + "</option>"
	}
	puts "</optgroup>"	
	puts "<optgroup label='Property Sets'>"
	file_name = $ifc_path + "/cache/#{$username}/" + $cgi['f'] + "/psets_per_class.hash"
	
	if File.exists?(file_name)		
	  data=open(file_name, "rb") {|io| io.read }
	  $psets_per_class = Marshal.load(data)
	  if $psets_per_class[cls.to_s] != nil
	  $psets_per_class[cls.to_s].each { |atts|
	    puts "<option style='background-color: #ccc; color: #000;' value='pset(\"" + atts[0].to_s.gsub("'","") + "\")'>" + atts[0].to_s.gsub("'","") + "</option>"
		atts[1..-1].each { |att|
	      att_arr << att.to_s
	      puts "<option value='p(\"" + atts[0].to_s.gsub("'","") + "." + att.to_s + "\")'>" + att.to_s + "</option>"
		  }
	  }
	  end
    end	
	puts "</optgroup>"	
	# Load Extensions	
	if $bLoadIFCExtensions then
		Dir[ $ifc_path + "/extensions/byclass/*.rb"].each {
		|file| load file 
		}
	end	
	puts "<optgroup label='Extension methods'>"
	cls.instance_methods(false).sort.each { |m|
	next if m.to_s.include?("=")
	next if att_arr.include?( m.to_s)
	puts "<option value='" + m.to_s + "'>" + m.to_s + "</option>"
	}
	puts "<option value='preview'>preview(image)</option>" if cls <= IFCPRODUCT 
	puts "</optgroup>"
end
