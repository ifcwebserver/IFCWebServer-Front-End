def create_select_box(name="q",label="",filter="Ifc",ancestorsFilter="",filter1="",style_str="",div_style="")		
	return ""  if ancestorsFilter != "" and not Object.const_defined?(ancestorsFilter)
	res_selected=""	
	num_of_classes= 0
	Object.constants.sort.each do |c|		
		if c.to_s.include?(filter) 
			oClass = Kernel.const_get(c.to_s.strip)			
			if oClass.ancestors.to_s.include?(ancestorsFilter)
				next if $ifcClassesNames[oClass.to_s] == nil or oClass.to_s == "IFC" or c.to_s.upcase == ancestorsFilter.upcase
				class_name=$ifcClassesNames[oClass.to_s].sub("Ifc","")				
				if $ifcClassesNames[oClass.to_s] != nil 
					res_selected += "<option value=\"" + oClass.to_s + "\">" + class_name + "</option>\n" 
					num_of_classes += 1
				end
			end
		end	
	end	 
	Object.constants.sort.each do |c|
		break if filter1 == ""
		if c.to_s.include?(filter1) 
			oClass = Kernel.const_get(c.strip)
			if oClass.ancestors.to_s.include?(ancestorsFilter)
				class_name=$ifcClassesNames[oClass.to_s].sub("Ifc","")
				class_name = "All classes" if oClass.to_s == "IFC"				
				if $ifcClassesNames[oClass.to_s] != nil
					res_selected += "<option value=\"" + oClass.to_s + "\">" + class_name + "</option>\n" 
					num_of_classes += 1
				end	
			end
		end	
	end		
	return "" if res_selected == ""
	res = "<td><div style='" + div_style + "' id='" + "div_" + name + "'>\n" + label + "(" + num_of_classes.to_s + ")"  
	res += "</br><select name=\"" + name + "\" size=\"8\"" + style_str + " multiple ondblclick=\"add_class(this,'" + name + "');\">"
	if ancestorsFilter != "" and $ifcClassesNames[Kernel.const_get(ancestorsFilter).to_s] != nil
	  res += "<option value=\"" + Kernel.const_get(ancestorsFilter).to_s + "\">" 
	  res += $ifcClassesNames[Kernel.const_get(ancestorsFilter).to_s].sub("Ifc","") + "s</option>\n" 
	end
	res += "<option SELECTED ></option>\n"	 
	res +=  res_selected
	res += "</select>\n</div></td>\n"
end