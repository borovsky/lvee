TSHIRT_SIZES = %w(S M L XL XXL)

NEW_STATUS = "new"
APPROVED_STATUS = "approved"
CANCELLED_STATUS = "cancelled"

IMAGE_WEB_ROOT = 'images/uploaded'
IMAGE_UPLOAD_ROOT = File.join(Rails.root, 'public', 'images', 'uploaded')


ALL_USER_MAILLIST = "maillist"
TALKS_MAILLIST = "talks"
ADMIN_MAILLIST = "orgmaillist"

AVATAR_SIZE = [500, 500]
LIST_AVATAR_SIZE = [100, 75]

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
STATISTICS_TYPES = [
  :total_registrations,
  :approved_registrations,
  :total_men,
  :approved_men,
]

TRANSPORT = %w(bus_minsk independent)

SPONSOR_TYPES = [
  ["sponsor", "sponsors"],
  ["technical", "technical_sponsor"],
  ["information", "information_sponsor"],
  ["tech_partner", "technical_partner"],
]

DEFAULT_LICENSE = "Creative Commons Attribution-ShareAlike 3.0"

LATEX_WS_BASE = 'http://www.codecogs.com/png.latex?'
