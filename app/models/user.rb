class User < ActiveRecord::Base
	EMAIL_REGEXP = /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

	validates_presence_of :email, :full_name, :location
	# campo obrigatorio

	# validates_confirmation_of :password 
	# deve ter um outro campo de imput para _confirmation para comparar os dois

	validates_length_of :bio, minimum: 30, allow_blank: false
	# diversos tipos de validação com tamanho de texto

	# validates_format_of: Valida o formato de um texto com uma expressão regular;
	# validates_inclusion_of:Validaainclusãodeumelementoemumenu- merável, ou seja, um número em um range ou um texto dentre uma lista de opções;
	# validates_numericality_of: Valida se o atributo passado é realmente um número, com algumas opções interessantes, por exemplo, :less_than, :greater_than, entre outros.
	
	validates_uniqueness_of :email
	# campo unico

	has_secure_password

	validate :email_format

	before_create do |user|
	    user.confirmation_token = SecureRandom.urlsafe_base64
	end

	def confirm!
	    return if confirmed?
	    self.confirmed_at = Time.current
	    self.confirmation_token = ''
	    save!
	end

	def confirmed?
	    confirmed_at.present?
	end

	scope :confirmed, -> { where.not(confirmed_at: nil) }

	def self.authenticate(email, password)
	  user = confirmed.find_by(email: email)
	  if user.present?
	    user.authenticate(password)
	  end
	end

	private
	  # Essa validação pode ser representada da seguinte forma:
	  # validates_format_of :email, with: EMAIL_REGEXP
	def email_format
	    errors.add(:email, :invalid) unless email.match(EMAIL_REGEXP)
	end
end
