module Zuora
  class Account

    # @return [Hash]
    def self.find(id)
      Zuora::Core.find("Account", id)
    end

    # @return [Hash]
    def self.find_by(**args)
      Zuora::Core.find_by("Account", **args)
    end

    # @return [Hash]
    def self.first
      Zuora::Core.first("Account")
    end

    # @return [Hash]
    def self.last
      Zuora::Core.last("Account")
    end

    #
    #  params = {
    #    additionalEmailAddresses: [],
    #    autoPay: false,
    #    billCycleDay: 1,
    #    billToContact: {
    #      address1: "中神田猿楽町２丁目１−１",
    #      city: "千代田区",
    #      country: "japan",
    #      firstName: "優",
    #      lastName: "森本",
    #      state: "東京都",
    #      zipCode: "101-0064"
    #    },
    #    currency: "JPY",
    #    hpmCreditCardPaymentMethodId: "",
    #    invoiceDeliveryPrefsEmail: false,
    #    invoiceDeliveryPrefsPrint: false,
    #    notes: "",
    #    paymentTerm: "",
    #    name: "株式会社cuon",
    #    crmId: "xxxxxxxxxxxxxxx"
    #  }
    # a = Zuora::Account.create!(params)
    # @return [Hash]
    def self.create!(params)
      Zuora::Core.create!("Account", params, "accountId")
    end

    # a = Zuora::Account.update!('a5deb3e3feb7e062b174ff1a0b07cf71', { name: 'test' })
    # @return [Hash]
    def self.update!(id, params)
      Zuora::Core.update!("Account", id, params)
    end
  end
end
