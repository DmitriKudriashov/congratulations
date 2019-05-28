module CompaniesPeopleHelper

  def list_companies_people(companies_people)
    c_p = []
    companies_people.each {|x|  c_p << [x.id, x.person.name + '; '+ x.company.name ] }
    c_p
  end

end
