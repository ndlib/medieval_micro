module MicrofilmsHelper

  def getCity(cityid)
    c = City.find(cityid)
    
    return c.name

  end

end
