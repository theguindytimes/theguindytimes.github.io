class Message < ActiveRecord::Base
    validates_format_of :email,
        :with => /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i,:multiline => true
end
