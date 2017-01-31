###    ____               _           __     ____________ ___  __
 #    / __ \_________    (_)__  _____/ /_   /  _/ ____/ //_/ |/ /
 #   / /_/ / ___/ __ \  / / _ \/ ___/ __/   / // /   / ,<  |   /
 #  / ____/ /  / /_/ / / /  __/ /__/ /_   _/ // /___/ /| |/   |
 # /_/   /_/   \____/_/ /\___/\___/\__/  /___/\____/_/ |_/_/|_|
 #                 /___/
 #
 # @author		wakaba
 # @copyright	Copyright 2015, Project ICKX. (http://www.ickx.jp/)
 # @license		MIT
 # @varsion		0.0.1
###

#
# 設定パート
#

# ライブラリ読み込み
require('./Ivu')

# 定数の設定
HOST_NAME = 'example.com'
DOMAIN_NAME = 'example.com'

#
# 仮想マシン設定
#
HOST_SPECS		= {
	'api'	=> {
		:HOST_NAME		=> "#{HOST_NAME}",
		:DOMAIN			=> "#{DOMAIN_NAME}",
		:SUB_DOMAIN		=> 'api',
		:CPU			=> 2,
		:MEMORY			=> 1024,
		:IP				=> '10.0.0.10',
		:PRIMARY		=> true
	},
	'web'	=> {
		:HOST_NAME		=> "#{HOST_NAME}",
		:DOMAIN			=> "#{DOMAIN_NAME}",
		:SUB_DOMAIN		=> 'www',
		:CPU			=> 2,
		:MEMORY			=> 1024,
		:IP				=> '10.0.0.11',
		:ALIAS			=> [
			"adm.#{DOMAIN_NAME}",
			"ssl.#{DOMAIN_NAME}"
		]
	},
	'db'	=> {
		:HOST_NAME		=> "#{HOST_NAME}",
		:DOMAIN			=> "#{DOMAIN_NAME}",
		:SUB_DOMAIN		=> 'db',
		:CPU			=> 1,
		:MEMORY			=> 1024,
		:IP				=> '10.0.0.12',
		:SYNCED_FOLDER	=> false
	}
}

#
# サンプルパート
#

# 引数一覧の表示
p Ivu.params

# 現在のサブコマンド
p Ivu.sub_command

# 現在のprovision with
p Ivu.provision_with

# 複数起動時の対象名
p Ivu.machine_name

# 仮想マシン設定をもとにhostsを作る
p Ivu.make_hosts(HOST_SPECS)

exit
