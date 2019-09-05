# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def table_present?(name)
  ActiveRecord::Base.connection.table_exists? name
end

# 1) Types

types = Type.create([
                      { name: 'Public' }, { name: 'Church' }, { name: 'Professional' }, { name: 'Private' }
                    ])
types = Type.all
# 2) Countries
countries = Country.create([
                             { name: 'All countries', code: 'ALL' },
                             { name: 'Ukraine', code: 'UA' },
                             { name: 'Germany', code: 'DE' },
                             { name: 'Cyprus', code: 'CY' },
                             { name: 'United Kingdom', code: 'GB' }
                           ])
countries = Country.all
# 3) Companies
companies = Company.create([
                             { name: 'OSKAR WEHR', country_id: countries[2].id },
                             { name: 'OAL', country_id: countries[4].id },
                             { name: 'Ukraine Companies', country_id: countries[1].id },
                             { name: 'Cyprus Companies', country_id: countries[3].id }
                           ])

companies = Company.all

# 4) Holidays
holidays = Holiday.create([{ name: 'Holiday 1', type_id: types[0].id },
                           { name: 'Holiday 2', type_id: types[0].id },
                           { name: 'Holiday 3', type_id: types[1].id },
                           { name: 'Holiday 4', type_id: types[1].id },
                           { name: 'Holiday 5', type_id: types[2].id },
                           { name: 'Holiday 6', type_id: types[2].id },
                           { name: 'Birthday', type_id: types[3].id }])
holidays = Holiday.all

# 5) CountriesHolidays
countries_holidays = CountriesHoliday.create([
                                               { country_id: countries[0].id, holiday_id: holidays[0].id },
                                               { country_id: countries[0].id, holiday_id: holidays[1].id  },
                                               { country_id: countries[1].id, holiday_id: holidays[2].id  },
                                               { country_id: countries[2].id, holiday_id: holidays[3].id  },
                                               { country_id: countries[3].id, holiday_id: holidays[4].id  }
                                             ])
countries_holidays = CountriesHoliday.all

# 6) Person
people = Person.create([
                         { name: 'Name1 Family1 Middle1', email: 'name1@domain1.com', birthday: Date.new(1970, 2, 5) },
                         { name: 'Name2 Family2 Middle2', email: 'name2@domain1.com', birthday: Date.new(1980, 3, 15) },
                         { name: 'Name3 Family3 Middle3', email: 'name3@domain2.com', birthday: Date.new(1975, 6, 25) },
                         { name: 'Name4 Family4 Middle4', email: 'name4@domain2.com', birthday: Date.new(1980, 8, 5) },
                         { name: 'Name5 Family5 Middle5', email: 'name5@domain2.com', birthday: Date.new(1990, 8, 25) },
                         { name: 'Name6 Family6 Middle6', email: 'name6@domain6.com', birthday: Date.new(1984, 9, 12) },
                         { name: 'Name7 Family7 Middle7', email: 'name7@domain6.com', birthday: Date.new(1999, 9, 25) }
                       ])
people = Person.all
# 7) CompaniesPerson
companies_people = CompaniesPerson.create([
                                            { company_id: companies[0].id, person_id: people[0].id },
                                            { company_id: companies[0].id, person_id: people[1].id },
                                            { company_id: companies[1].id, person_id: people[0].id },
                                            { company_id: companies[1].id, person_id: people[2].id },
                                            { company_id: companies[1].id, person_id: people[3].id },
                                            { company_id: companies[2].id, person_id: people[4].id },
                                            { company_id: companies[2].id, person_id: people[5].id },
                                            { company_id: companies[2].id, person_id: people[6].id },
                                            { company_id: companies[3].id, person_id: people[2].id },
                                            { company_id: companies[3].id, person_id: people[6].id }
                                          ])

companies_people = CompaniesPerson.all

# 8) Cardtext
cardtexts = Cardtext.create([
                              { filename: 'File text 1', text: 'Congratulation 1', holiday_id: holidays[0].id },
                              { filename: 'File text 2', text: 'Congratulation 2', holiday_id: holidays[1].id  },
                              { filename: 'File text 3', text: 'Congratulation 3', holiday_id: holidays[2].id  },
                              { filename: 'File text 4', text: 'Congratulation 4', holiday_id: holidays[3].id  },
                              { filename: 'File text 5', text: 'Congratulation 5', holiday_id: holidays[4].id  },
                              { filename: 'File text 6', text: 'Congratulation 6', holiday_id: holidays[5].id  }
                            ])

cardtexts = Cardtext.all

# 9) DatesHolidays
dates_holidays = DatesHoliday.create([
                                       { day: 1, month: 3, year: 0, holiday_id: holidays[0].id, date: Date.new(2000, 3, 1) },
                                       { day: 15, month: 6, year: 0, holiday_id: holidays[1].id, date: Date.new(2000, 6, 15) },
                                       { day: 12, month: 8, year: 0, holiday_id: holidays[2].id, date: Date.new(2000, 8, 12) },
                                       { day: 30, month: 9, year: 0, holiday_id: holidays[3].id, date: Date.new(2000, 9, 30) },
                                       { day: 20, month: 7, year: 0, holiday_id: holidays[4].id, date: Date.new(2000, 7, 20) },
                                       { day: 19, month: 10, year: 0, holiday_id: holidays[5].id, date: Date.new(2000, 10, 19) },
                                       { day: 21, month: 11, year: 0, holiday_id: holidays[5].id, date: Date.new(2000, 11, 21) }
                                     ])
dates_holidays = DatesHoliday.all

# 10) MailAddress
mail_adresses = MailAddress.create([
                                     { email: 'email1@gmail.com', companies_person_id: companies_people[0].id },
                                     { email: 'email2@gmail.com', companies_person_id: companies_people[1].id },
                                     { email: 'email3@gmail.com', companies_person_id: companies_people[2].id },
                                     { email: 'email4@gmail.com', companies_person_id: companies_people[3].id },
                                     { email: 'email5@gmail.com', companies_person_id: companies_people[4].id },
                                     { email: 'email6@gmail.com', companies_person_id: companies_people[5].id },
                                     { email: 'email7@gmail.com', companies_person_id: companies_people[6].id }
                                   ])

mail_adresses = MailAddress.all

# 11) CompaniesHoliday
companies_holidays = CompaniesHoliday.create([
                                               { company_id: companies[0].id, holiday_id: holidays[0].id },
                                               { company_id: companies[0].id, holiday_id: holidays[1].id },
                                               { company_id: companies[0].id, holiday_id: holidays[2].id },
                                               { company_id: companies[0].id, holiday_id: holidays[3].id },

                                               { company_id: companies[1].id, holiday_id: holidays[0].id },
                                               { company_id: companies[1].id, holiday_id: holidays[1].id },
                                               { company_id: companies[1].id, holiday_id: holidays[2].id },
                                               { company_id: companies[1].id, holiday_id: holidays[3].id },
                                               { company_id: companies[1].id, holiday_id: holidays[4].id },
                                               { company_id: companies[1].id, holiday_id: holidays[5].id },

                                               { company_id: companies[2].id, holiday_id: holidays[0].id },
                                               { company_id: companies[2].id, holiday_id: holidays[1].id },
                                               { company_id: companies[2].id, holiday_id: holidays[4].id },
                                               { company_id: companies[2].id, holiday_id: holidays[5].id },

                                               { company_id: companies[3].id, holiday_id: holidays[2].id },
                                               { company_id: companies[3].id, holiday_id: holidays[3].id },
                                               { company_id: companies[3].id, holiday_id: holidays[4].id },
                                               { company_id: companies[3].id, holiday_id: holidays[5].id },
                                               { company_id: companies[3].id, holiday_id: holidays[1].id }
                                             ])

companies_holidays = CompaniesHoliday.all

# ) Email
#    emails
# 10) Postcard
# postcards = Postcard.create([
#                             ])

# 11) EmailCard
#    email_cards
# 12) EmailText
#    email_texts
