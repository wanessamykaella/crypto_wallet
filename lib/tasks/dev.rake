namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando BD...") {%x(rails db:drop)}
      show_spinner("Criando BD...") {%x(rails db:create)}
      show_spinner("Migrando BD...") {%x(rails db:migrate)}
      %x(rails dev:add_mining_types)
      %x(rails dev:add_coins)


    else
      puts "Você não está em ambiente de desenvolvimento!/You are not in a development environment!"
    end
  end

  desc "Cadastra moedas"
  task add_coins: :environment do
    show_spinner("Cadastrando moedas...") do
    coins = [
              { description: "Bitcoin",
                acronym: "BTC",
                url_image: "https://logos-world.net/wp-content/uploads/2020/08/Bitcoin-Emblem.png",
                mining_type: MiningType.find_by(acronym: 'PoW')
              },

              { description: "Ethereum",
                acronym: "ETH",
                url_image: "https://www.digitalhot.com.br/wp-content/uploads/2017/07/O-que-e-ethereum.png",
                mining_type: MiningType.all.sample
              },

              { description: "Litecoin",
                acronym: "LTC",
                url_image: "https://img2.gratispng.com/20180410/dew/kisspng-litecoin-bitcoin-cryptocurrency-ethereum-dogecoin-24-hours-5acd0d14617ad3.1455739215233876683993.jpg",
                mining_type: MiningType.all.sample
              },

              { description: "Dash",
                acronym: "DASH",
                url_image: "https://www.pinclipart.com/picdir/middle/556-5565319_dash-coin-png-email-contact-clipart.png",
                mining_type: MiningType.all.sample
              },

              { description: "Binance Coin",
                acronym: "BCH",
                url_image: "https://seeklogo.com/images/B/binance-coin-bnb-logo-97F9D55608-seeklogo.com.png",
                mining_type: MiningType.all.sample
              }
            ]

    coins.each do |coin|
      Coin.find_or_create_by!(coin)
    end
  end
end

desc "Cadastra os tipos de mineração"
task add_mining_types: :environment do
  show_spinner("Cadastrando tipos de mineração...") do
  mining_types = [
    {description: "Proof of Work", acronym: "PoW"},
    {description: "Proof of Stake", acronym: "PoS"},
    {description: "Proof of Capacity", acronym: "PoC"},
  ]

  mining_types.each do |mining_type| #primeiro no plural e depois no singular
    MiningType.find_or_create_by!(mining_type) #no singular igual o controller
    end
  end
end

private

  def show_spinner(msg_start, msg_end = "Concluído com sucesso!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("Concluído!!")
  end
end
