###    ____               _           __     ____________ ___  __
 #    / __ \_________    (_)__  _____/ /_   /  _/ ____/ //_/ |/ /
 #   / /_/ / ___/ __ \  / / _ \/ ___/ __/   / // /   / ,<  |   /
 #  / ____/ /  / /_/ / / /  __/ /__/ /_   _/ // /___/ /| |/   |
 # /_/   /_/   \____/_/ /\___/\___/\__/  /___/\____/_/ |_/_/|_|
 #                 /___/
 #
 # Project ICKX Vagrant Utility
 #
 # @author		wakaba
 # @copyright	Copyright 2016, Project ICKX. (http://www.ickx.jp/)
 # @license		MIT
 # @varsion		1.0.0
###

#
# Ickx Vagrant Utility
#
# Vagrantfileでの制御を少し楽にするクラスです。
#
class Ivu
	# @return	[String]	vagrantのデフォルトユーザ
	DEFAULT_USER	= 'vagrant'

	# @return	[String]	vagrantのデフォルトグループ
	DEFAULT_GROUP	= 'vagrant'

	# @return	[String]	vagrantのデフォルトパスワード
	DEFAULT_PASSWORD	= 'vagrant'

	# @return	[Array]	起動オプションパラメータ配列
	@@params = nil

	#
	# vagrant起動オプションパラメータを配列として返します。
	#
	# @example
	#	vagrant up
	#		{"sub_command": "up"}
	#	vagrant up web
	#		{"sub_command": "up", "name" : "web"}
	#	vagrant up web --provision-with setup
	#		{"sub_command": "up", "name" : "web",  "provision-with": "setup"}
	#
	# @return [Array] vagrant起動オプションパラメータの配列
	def self.params
		if @@params == nil then
			params = {}

			args = ARGV
			params[:SUB_COMMAND] = args.shift

			current_option = nil
			arg = name = args.shift
			if arg =~ /^\-\-(.+)/ then
				current_option = $1
				params[current_option] = true
			else
				params[:MACHINE_NAME] = arg
			end

			args.each do |arg|
				if arg =~ /^\-\-(.+)/ then
					current_option = $1
					params[current_option] = true
				elsif arg =~ /^\-(.+)/ then
					current_option = $1
					params[current_option] = true
				elsif current_option != nil then
					params[current_option] = arg
					current_option = nil
				else
					if params.has_key?(:MACHINE_NAME) then
						params[arg] = arg
					else
						params[:MACHINE_NAME] = arg
					end
				end
			end

			@@params = params
		end

		return @@params
	end

	#
	# vagrant起動時のサブコマンドを返します。
	#
	# @example
	#	vagrant up
	#		"up"
	#
	#	vagrant provision --provision-with setup
	#		"provision"
	#
	# @return [String] vagrant起動時のサブコマンド
	#
	def self.sub_command
		return self.params.has_key?(:SUB_COMMAND) ? self.params[:SUB_COMMAND] : nil
	end

	#
	# vagrant起動時のprovision_withの値を返します。
	#
	# @example
	#	vagrant up --provision_with init
	#		"init"
	#
	#	vagrant provision web --provision-with setup
	#		"setup"
	#
	# @return [String] vagrant起動時のサブコマンド
	#
	def self.provision_with
		return self.params.has_key?('provision-with') ? self.params['provision-with'] : nil
	end

	#
	# vagrant起動時の仮想マシン名の値を返します。
	#
	# @example
	#	vagrant up web --provision_with init
	#		"web"
	#
	#	vagrant provision --provision-with setup web
	#		"web"
	#
	# @return [String] vagrant起動時の仮想マシン名
	#
	def self.machine_name
		return self.params.has_key?(:MACHINE_NAME) ? self.params[:MACHINE_NAME] : nil
	end

	#
	# vagrant起動時のサブコマンドが引数と同じか判定します。
	#
	# @param	[String]	sub_command	判定したいサブコマンド名
	#
	# @example
	#	vagrant up --provision_with setup
	#	Ivu.sub_command?('up')
	#		true
	#
	#	vagrant provision web --provision-with setup
	#	Ivu.sub_command?('up')
	#		false
	#
	# @return [Bool] vagrant起動時のサブコマンドだった場合treu、そうでない場合false
	#
	def self.sub_command? (sub_command)
		return self.params[:SUB_COMMAND] == sub_command
	end

	#
	# vagrant起動時のprovision-withが引数と同じか判定します。
	#
	# @param	[String]	provision_with	判定したいprovision-with
	#
	# @example
	#	vagrant up --provision-with init
	#	Ivu.provision_with?('init')
	#		true
	#
	#	vagrant provision web --provision-with setup
	#	Ivu.provision_with?('init')
	#		false
	#
	# @return [Bool] vagrant起動時のprovision-withだった場合treu、そうでない場合false
	#
	def self.provision_with? (provision_with)
		return self.params['provision-with'] == provision_with
	end

	#
	# vagrant起動時の仮想マシン名が引数と同じか判定します。
	#
	# @param	[String]	machine_name	判定したい仮想マシン名
	#
	# @example
	#	vagrant up web --provision-with init
	#	Ivu.machine_name?('web')
	#		true
	#
	#	vagrant provision web --provision-with setup
	#	Ivu.machine_name?('web')
	#		false
	#
	# @return [Bool] vagrant起動時の仮想マシン名だった場合treu、そうでない場合false
	#
	def self.machine_name? (machine_name)
		return self.params[:MACHINE_NAME] == machine_name
	end

	#
	# HOST_SPECSとして定義したハッシュをもとにhosts用の設定の配列を生成します。
	#
	# @param	[Hash]		host_specs	生成元のハッシュ
	#
	# @return	[String]	hosts用文字列
	#
	def self.make_hosts (host_specs)
		domain_list = []

		host_specs.each do | name, spec |
			if !spec.has_key?(:HOST) && !spec.has_key?(:DOMAIN) && !spec.has_key?(:ALIAS) then
				next
			end

			conf_list = ["#{spec[:IP]}"]

			if spec.has_key?(:HOST) || spec.has_key?(:DOMAIN) then
				domain = spec.has_key?(:DOMAIN) ? spec[:DOMAIN] : spec[:HOST]
				full_domain = spec.has_key?(:SUB_DOMAIN) ? "#{spec[:SUB_DOMAIN]}.#{domain}" : "#{domain}"
				conf_list << "#{full_domain}"
			end

			if spec.has_key?(:ALIAS) then
				for host_alias in spec[:ALIAS] do
					conf_list << "#{host_alias}"
				end
			end
			domain_list << conf_list.join(' ')
		end

		return domain_list
	end

	#
	# HOST_SPECS上のhostに紐づく値を取得します。
	#
	# @param	[Hash]		host_specs	生成元のハッシュ
	# @param	[String]	name		マシン名
	# @param	[String]	key			設定名
	#
	# @return	[String|Int|Array|Hash]	HOST_SPECS上のhostに紐づく値
	#
	def self.host_value (host_specs, name, key)
		if !host_specs.has_key?(name) then
			return nil
		end
		if !host_specs[name].has_key?(key) then
			return nil
		end
		return host_specs[name][key]
	end

	#
	# Project ICKX標準のディレクトリリストを作成します。
	#
	# @param	[String]	vender_name		アプリケーションベンダー名
	# @param	[String]	machine_name	マシン名
	#
	# @return	[Hash]	Project ICKX標準のディレクトリリスト
	#
	def self.build_dir_list (vender_name, machine_name = nil)
		machine_name = machine_name == nil ? '' : "/#{machine_name}"

		apps_dir			= "/srv/apps/#{vender_name}"
		build_dir			= "#{apps_dir}/build"
		var_dir				= "#{apps_dir}/var"

		provision_dir		= "#{build_dir}/provision"
		machine_name_dir	= "#{provision_dir}#{machine_name}"

		return {
			:LOCAL_APPS_DIR		=> ".",
			:LOCAL_BUILD_DIR	=> "./build",
			:LOCAL_VAR_DIR		=> "./var",
			:APPS_DIR			=> "#{apps_dir}",
			:SRC_DIR			=> "#{apps_dir}/src",
			:BUILD_DIR			=> "#{build_dir}",
			:CONFIG_DIR			=> "#{build_dir}/config",
			:DOCS_DIR			=> "#{build_dir}/docs",
			:MIDDLEWARE_DIR		=> "#{build_dir}/middlewear",
			:PROVISION_DIR		=> "#{provision_dir}",
			:MACHINE_NAME_DIR	=> "#{machine_name_dir}",
			:SERVER_DIR			=> "#{machine_name_dir}/server",
			:SHELL_DIR			=> "#{machine_name_dir}/shell",
			:VAR_DIR			=> "#{var_dir}",
			:LOG_DIR			=> "#{var_dir}/log/build#{machine_name}"
		}
	end

	#
	# 接頭辞が"LOCAL_"のキーを除外して返します。
	#
	# @param	[*Hash]		env_list_set	環境変数設定ハッシュ 可変引数として複数設定可能
	#
	# @return	[Hash]	キーの接頭辞がLOCAL_以外の環境変数設定ハッシュ
	#
	def self.filter_local_env (*env_list_set)
		env_list = {}
		for env_set in env_list_set do
			env_list.update(env_set)
		end

		env_list.each do | name, path |
			if name !=~ /^LOCAL_/ then
				env_list.store(name, path)
			end
		end

		return env_list
	end
end
