module Zuora
  class Contact
    # @return [Hash]
    def self.find(id)
      Zuora::Core.find("Contact", id)
    end

    # @return [Hash]
    def self.find_by(**args)
      Zuora::Core.find_by("Contact", **args)
    end

    #
    # params = {
    #   AccountId: "8ad09b7a7d989cd0017d9b92675148af",
    #   Address1: "中神田猿楽町２丁目１−１",
    #   City: "千代田区",
    #   Country: "japan",
    #   PostalCode: "101-0064",
    #   State: "東京都",
    #   FirstName: "優",
    #   LastName: "森本",
    #   MobilePhone: "",
    #   NickName: "",
    #   PersonalEmail: "",
    #   TaxRegion: "JP",
    #   WorkEmail: "morimoto@example.com"
    # }
    # c = Zuora::Contact.create!(params)
    def self.create!(params)
      Zuora::Core.create!("Contact", params, "Id")
    end

    # a = Zuora::Contact.update!('8ad0965d7d134b0e017d20376abd0d98', { LastName: 'test' })
    # @return [Hash]
    def self.update!(id, params)
      Zuora::Core.update!("Contact", id, params)
    end
  end
end
