unless String.new.respond_to? 'blank?'
  class String
    def blank?
      self.nil? || self.empty?
    end
  end
end