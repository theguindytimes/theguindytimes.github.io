class Feedback < ActionMailer::Base
    default from: "prashant.barca@gmail.com"
    def feed(name,email,subject,body)
        @body=body
        @email=email
        @name=name
        mail :to => email, :from => "President", :subject => "The Guindy Times: #{subject}"
    end
    def response(name,email,subject,body)
        @body=body
        @email=email
        @name=name
        mail :to => "srravya.c@gmail.com,adnanalime@gmail.com,prashant.barca@gmail.com", :from => "President", :subject => "The Guindy Times: #{subject}"
    end
end
