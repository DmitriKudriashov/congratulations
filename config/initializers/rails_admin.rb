RailsAdmin.config do |config|

  config.main_app_name = ["CONGRATULATION", " Admin "]
  # or something more dynamic
  config.main_app_name = Proc.new { |controller| [ "CONGRATULATIONS", "Administration - #{controller.params[:action].try(:titleize)}" ] }


  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete

   # show_in_app # kds 070619

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
# ========= from scm
# RailsAdmin.config do |config|

#   ### Popular gems integration

#   # == Devise ==
#   config.authenticate_with do
#     warden.authenticate! scope: :user
#   end
#   config.current_user_method(&:current_user)

#   ## == Cancan ==
#   config.authorize_with :cancancan

#   ## == Pundit ==
#   # config.authorize_with :pundit

#   ## == PaperTrail ==
#   # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

#   ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

#   ## == Gravatar integration ==
#   ## To disable Gravatar integration in Navigation Bar set to false
#   # config.show_gravatar = true

#   config.actions do
#     dashboard                     # mandatory
#     index                         # mandatory
#     new
#     export
#     bulk_delete
#     show
#     edit
#     delete
#     show_in_app

#     ## With an audit adapter, you can add:
#     # history_index
#     # history_show
#   end
#   config.included_models = []
#   begin
#     config.included_models += ActiveRecord::Base.connection.tables.map{|m| m.capitalize.singularize.camelize}
#     config.included_models += User.connection.tables.map{|m| m.capitalize.singularize.camelize}
#   rescue
#   end

# end
#
