TSHIRT_SIZES = %w(M L XL XXL)


NEW_STATUS = "new"
APPROVED_STATUS = "approved"

IMAGE_WEB_ROOT = 'images/uploaded'
IMAGE_UPLOAD_ROOT = File.join(RAILS_ROOT, 'public', 'images', 'uploaded')


ALL_USER_MAILLIST = "maillist"
ADMIN_MAILLIST = "orgmaillist"

AVATAR_SIZE = "200x150"
LIST_AVATAR_SIZE = "100x75"

RANDOM_PHOTOS_ROOT = 'images/random_photos'

# Map old language names to new
LANGUAGE_MAP = {
  "by" => "be",
  "ua" => "uk"
}

# Diff stuff
INS_STYLE = "background-color: #AAFFAA; text-decoration:none;"
DEL_STYLE = "background-color: #FF9999; text-decoration:none;"
INS_CLASS = "ins"
DEL_CLASS = "del"

# Statistics
STATISTICS_TYPES = {
  :total_registrations => "Total conference registrations",
  :approved_registrations => "Approved conference registrations",
  :total_men => "Total men",
  :approved_men => "Approved men",
}

TRANSPORT = %w(bus_minsk bus_grodno independent)
