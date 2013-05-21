require 'jumpstart_auth'
require 'bitly'
require 'klout'

class MicroBlogger
  attr_reader :client
  
  def initialize
    puts "Initializing"
    @client = JumpstartAuth.twitter
    Klout.api_key = 'xu9ztgnacmjx3bu82warbr3h'
  end
  
  def tweet(message)
    if message.size > 140
      puts "Message is over 140 characters"
    else
      @client.update(message)
    end
  end
  
  def dm(target, message)
    if message.size > 140
      puts "Message is too laaaarrrrgggeeee"
    else
      dirmes = "d "+target+" "+message
      puts dirmes
      #messed up iteration 2
      #screen_names = @client.followers.collect{|follower| follower.screen_name}
      #puts screen_names
      #if screen_names.include?(target)
        @client.update(dirmes)
        #else
        #puts "Sorry that user don't like you!"
        #end
    end
  end
  def followers_list
    screen_names = []
    @client.followers.each{|x|
      screen_names << x.screen_name
    }
    print screen_names
  end
  
  def spam_my_friends
    followers_list.each { |x|
      self.dm(x,"haha suckas you got spammed")
    }
  end
  
  def everyones_last_tweet
    friends = @client.friends
    friends.sort_by! {|x|
      x.screen_name.downcase
    }
    friends.each {|x|
      puts x.screen_name + " said..."      
      puts x.status.text
      puts ""
    }

  end
  
  def shorten(original_url)
    Bitly.use_api_version_3
    bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
    return bitly.shorten(original_url).short_url
  end
  
  def kloutit
    
    screen_names = @client.friends.collect{|f| f.screen_name}
    screen_names.each {|x|
      identity = Klout::Identity.find_by_screen_name(x)
      user = Klout::User.new(identity.id)
      puts x
      puts user.score.score    
    }

  end
  
  def run
    puts "Welcome to the JSL Twitter Client!"
    command = ""
    while command != "q"
      printf "enter command: "
      input  = gets.chomp
      parts = input.split(" ")
      command = parts[0]
      case command
        when "q" then puts "Goodbye"
        when "t" then self.tweet(parts[1..-1].join(" "))
        when "dm" then self.dm(parts[1], parts[2..-1].join(" "))
        when "follow" then self.followers_list
        when "elt" then everyones_last_tweet
        when "s" then self.shorten(parts[1])
        when "turl" then self.tweet(parts[1..-2].join(" ")+" "+shorten(parts[-1]))
        when "k" then kloutit
      else
        puts "Sorry, we didn't recognize command #{command}"
      end
    end
  end
end


blogger = MicroBlogger.new
blogger.run
