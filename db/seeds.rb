# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 1) Countries
  # countries = Country.create([
  #                             { name: 'Ukraine', code: "UA" },
  #                             { name: 'Germany', code: "DE" },
  #                             { name: 'United Kingdom', code: "GB" }
  #                           ])

# 2) Companies
#    companies
  # companies = Company.create([{ name: 'OSKAR WEHR', country_id: countries[1]},
  #                           { name: 'OAL', country_id: countries[2]},
  #                           { name: 'Ukraine Companies', country_id: countries[0]},
  #                           { name: 'Company 4', country_id: countries[0]}])
# 3) Holidays
  # holidays = Holiday.create([{name: "Holiday 1", country_id: countries[0]},
  #                             {name: "Holiday 2", country_id: countries[0]},
  #                             {name: "Holiday 3", country_id: countries[0]},
  #                             {name: "Holiday 4", country_id: countries[0]},
  #                             {name: "Holiday 5", country_id: countries[0]}])
# 4) CountriesHolidays
  # countries_holidays = CountriesHoliday.create([
  #                       {country_id: countries[0], holiday_id: holidays[0] },
  #                       {country_id: countries[0], holiday_id: holidays[1] },
  #                       {country_id: countries[0], holiday_id: holidays[2] },
  #                       {country_id: countries[0], holiday_id: holidays[3] },
  #                       {country_id: countries[0], holiday_id: holidays[4] },
  #                       ])

# 5) Person
#   people = Person.create([
#                           {name: "Name1 Family1 Middle1", email: "name1@domain1.com", country_id: countries[0], company_id: companies[0]},
#                           {name: "Name2 Family2 Middle2", email: "name2@domain1.com", country_id: countries[0], company_id: companies[0]},
#                           {name: "Name3 Family3 Middle3", email: "name3@domain2.com", country_id: countries[0], company_id: companies[1]},
#                           {name: "Name4 Family4 Middle4", email: "name4@domain2.com", country_id: countries[0], company_id: companies[1]},
#                           {name: "Name5 Family5 Middle5", email: "name5@domain2.com", country_id: countries[0], company_id: companies[2]},
#                           {name: "Name6 Family6 Middle6", email: "name6@domain6.com", country_id: countries[0], company_id: companies[2]},
#                           {name: "Name7 Family7 Middle7", email: "name7@domain6.com", country_id: countries[0], company_id: companies[3]}
#                         ])
# # 6) CompaniesPerson
  # companies_people = CompaniesPerson.create([
  #                                             {company_id: companies[0], person_id: people[0]},
  #                                             {company_id: companies[0], person_id: people[1]},
  #                                             {company_id: companies[0], person_id: people[2]},
  #                                             {company_id: companies[0], person_id: people[3]},
  #                                           ])
# 7) Email
#    emails
# 8) Postcard
#    postcards
# 9) Cardtext
#    cardtexts
# 10) EmailCard
#    email_cards
# 11) EmailText
#    email_texts
