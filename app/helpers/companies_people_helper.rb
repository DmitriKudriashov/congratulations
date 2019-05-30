module CompaniesPeopleHelper

  def list_companies_people(companies_people)
    c_p = []
    companies_people.each {|x|  c_p << [x.id, person_company_name(x) ] }
    c_p
  end
  def person_company_name(x)
    "#{x.person.name} / #{x.company.name}"
  end
end
