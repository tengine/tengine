# -*- coding: utf-8 -*-
require 'pp'

class Combination

  
  def result_node(node_depth)
    # 前後の依存関係
    next_node_hash = {
      "DBサービスの起動" => [
        "Tengineプロセスの起動",
        "Tengineコアパッケージの更新",
        "Tengineコアパッケージのロールバック",
        "DBのリストア",
        "DBのリカバリ",
        "DBのマイグレーション",
        "DBのロールバック",
        "イベントハンドラ定義のデプロイ",
        "イベントハンドラ定義のロールバック",
      ],
      
      "DBサービスの停止" => [
        "DBサービスの起動",
        "DBパッケージの更新",
        "DBパッケージのロールバック",
        "Tengineコアパッケージの更新",
        "Tengineコアパッケージのロールバック",
        "DBのリストア(物理ファイル)",
        "DBのバックアップ(物理ファイル)",
      ],
      
      "Tengineプロセスの起動" => [
        "イベントドライバの有効化",
        "イベントドライバの無効化",
      ],
      
      "Tengineプロセスの停止" => [
        "DBサービスの停止",
        "Tengineプロセスの起動",
        "Tengineコアパッケージの更新",
        "Tengineコアパッケージのロールバック",
        "DBのリストア",
        "DBのリカバリ",
        "DBのマイグレーション",
        "DBのロールバック",
        "イベントドライバの有効化",
        "イベントドライバの無効化",
        "イベントハンドラ定義のデプロイ",
        "イベントハンドラ定義のロールバック",
      ],
      
#      "Tengineプロセスの再起動" => [],
      
      "DBパッケージの更新" => [
        "DBサービスの起動",
        "Tengineコアパッケージの更新",
        "Tengineコアパッケージのロールバック",
        "DBのバックアップ(物理ファイル)",
      ],
      
      "DBパッケージのロールバック" => [
        "DBサービスの起動",
        "Tengineコアパッケージの更新",
        "Tengineコアパッケージのロールバック",
        "DBのバックアップ(物理ファイル)",
      ],
      
      
      "Tengineコアパッケージの更新" => [
        "DBサービスの起動",
        "DBサービスの停止",
        "Tengineプロセスの起動",
        "DBパッケージの更新",
        "DBパッケージのロールバック",
        "DBのマイグレーション",
        "イベントドライバの有効化",
        "イベントドライバの無効化",
        "イベントハンドラ定義のデプロイ",
        "イベントハンドラ定義のロールバック",
        "DBのバックアップ(物理ファイル)",
      ],
      
      "Tengineコアパッケージのロールバック" => [
        "DBサービスの起動",
        "DBサービスの停止",
        "Tengineプロセスの起動",
        "DBパッケージの更新",
        "DBパッケージのロールバック",
        "DBのロールバック",
        "イベントドライバの有効化",
        "イベントドライバの無効化",
        "イベントハンドラ定義のデプロイ",
        "イベントハンドラ定義のロールバック",
        "DBのバックアップ(物理ファイル)",
      ],
      
      "DBのバックアップ(物理ファイル)" => [
        "DBサービスの起動",
        "DBパッケージの更新",
        "DBパッケージのロールバック",
        "Tengineコアパッケージの更新",
        "Tengineコアパッケージのロールバック",
       ],

      "DBのリストア" => [
        "Tengineプロセスの起動",
        "Tengineコアパッケージの更新",
        "Tengineコアパッケージのロールバック",
        "DBのリカバリ",
        "DBのマイグレーション",
        "DBのロールバック", 
        "イベントドライバの有効化",
        "イベントドライバの無効化",
        "イベントハンドラ定義のデプロイ",
      ],
      
      "DBのリストア(物理ファイル)" => [
        "DBサービスの起動",
        "DBパッケージの更新",
        "DBパッケージのロールバック",
        "Tengineコアパッケージの更新",
        "Tengineコアパッケージのロールバック",
      ],
      
      "DBのリカバリ" => [
        "Tengineプロセスの起動",
        "Tengineコアパッケージの更新",
        "Tengineコアパッケージのロールバック",
        "DBのマイグレーション",
        "DBのロールバック",
        "イベントドライバの有効化",
        "イベントドライバの無効化",
        "イベントハンドラ定義のデプロイ",
        "イベントハンドラ定義のロールバック",
      ],
      
      
      "DBのマイグレーション" => [
        "Tengineプロセスの起動",
        "Tengineコアパッケージの更新",
        "Tengineコアパッケージのロールバック",
        "DBのリカバリ",
        "イベントドライバの有効化",
        "イベントドライバの無効化",
      ],
      
      "DBのロールバック" => [
        "Tengineプロセスの起動",
        "Tengineコアパッケージの更新",
        "Tengineコアパッケージのロールバック",
        "DBのリカバリ",
        "イベントドライバの有効化",
        "イベントドライバの無効化",
      ],
      
      "イベントドライバの有効化" => [
        "Tengineプロセスの起動",
        "Tengineコアパッケージの更新",
        "Tengineコアパッケージのロールバック",
        "イベントドライバの無効化",
      ],
      
      "イベントドライバの無効化" => [
        "Tengineプロセスの起動",
        "Tengineコアパッケージの更新",
        "Tengineコアパッケージのロールバック",
        "イベントドライバの有効化",
      ],
      
      "イベントハンドラ定義のデプロイ" => [
        "Tengineプロセスの起動",
        "DBのマイグレーション",
        "Tengineコアパッケージの更新",
        "Tengineコアパッケージのロールバック",
        "イベントドライバの有効化",
        "イベントドライバの無効化",
      ],
      
      "イベントハンドラ定義のロールバック" => [
        "Tengineプロセスの起動",
        "Tengineコアパッケージの更新",
        "Tengineコアパッケージのロールバック",
        "イベントドライバの有効化",
        "イベントドライバの無効化",
      ],
      
    }

    results = []
  
    origins = next_node_hash.keys.reject{|name| name =~ /^DBパッケージの|Tengineコアパッケージの/ }
  
    calc_combinations = lambda do |depth|
      return if depth < 1
      if depth == 1
        result = origins.map{|node| [node]}
        results.concat(result)
        result
      else
        node_paths = calc_combinations.call(depth - 1)
        #    pp node_paths
        result = []
        node_paths.each do |node_path|
          next_node_hash[node_path.last].each do |next_node|
            result << (node_path + [next_node])
          end
        end
        
        # 同じ操作を2回行なうことはない
        result.reject! do |path|
          except_package = path
          except_package.any? do |node|
            except_package.count(node) > 1
          end
        end
      
        # DBパッケージのロールバックとDBパッケージの更新を同時に行なうことはない
        result.reject! do |path|
          path.index("DBパッケージのロールバック") && path.index("DBパッケージの更新")
        end
        
        # TengineコアパッケージのロールバックとTengineコアパッケージの更新を同時に行なうことはない
        result.reject! do |path|
          path.index("Tengineコアパッケージのロールバック") && path.index("Tengineコアパッケージの更新")
        end
        
        # イベントハンドラ定義のデプロイとイベントハンドラ定義のロールバックを同時に行うことはない
        result.reject! do |path|
          path.index("イベントハンドラ定義のデプロイ") && path.index("イベントハンドラ定義のロールバック")
        end

        # DBのリストアとDBのリストア(物理ファイル)を同時に行なうことはない
        result.reject! do |path|
          path.index("DBのリストア") && path.index("DBのリストア(物理ファイル)")
        end
        
        results.concat(result)
        result
      end
    end
    
    calc_combinations.call(node_depth.to_i)
    
    # 同じ操作を2回行なうことはない
    # ※展開時に処理をおこうなうことにした
    #result.reject! do |path|
    #  except_package = path
    #  except_package.any? do |node|
    #    except_package.count(node) > 1
    #  end
    #end
    
    
    # パッケージのロールバックとパッケージの更新を同時に行なうことはない
    # ※展開時に処理をおこうなうことにした
    #results.reject! do |path|
    #  path.index("パッケージのロールバック") && path.index("パッケージの更新")
    #end
    
    
    # Tengineプロセスは必ず停止で終わる事はない
    results.reject! do |path|
      if shutdown_idx = path.index("Tengineプロセスの停止")
        if launch_idx = path.index("Tengineプロセスの起動")
          launch_idx < shutdown_idx
        else
          true
        end
      else
        false
      end
    end
    
    # DBパッケージの更新は、DBサービスの停止の後に行なう
    # (パッケージの更新がある場合は、それ以前にTengineプロセスの停止またはDBサービスの停止があること)
    results.reject! do |path|
      if update_package_idx = path.index("DBパッケージの更新")
        if shutdown_db_idx = path.index("DBサービスの停止")
          update_package_idx < shutdown_db_idx
        else
          true
        end
      else
        false
      end
    end

    # Tengineコアパッケージの更新は、Tengineプロセスの停止の後に行なう
    # (パッケージの更新がある場合は、それ以前にTengineプロセスの停止またはDBサービスの停止があること)
    results.reject! do |path|
      if update_package_idx = path.index("Tengineコアパッケージの更新")
        if shutdown_tengine_idx = path.index("Tengineプロセスの停止") 
          update_package_idx < shutdown_tengine_idx
        else
          true
        end
      else
        false
      end
    end
    
    
    # DBパッケージのロールバックは、DBサービスの停止の後に行なう
    results.reject! do |path|
      if update_package_idx = path.index("DBパッケージのロールバック")
        shutdown_db = false
        if shutdown_db_idx = path.index("DBサービスの停止")
          update_package_idx < shutdown_db_idx
        else
          true
        end
      else
        false
      end
    end

    # Tengineコアパッケージのロールバックは、Tengineプロセスの停止、または、DBサービスの停止の後に行なう
    results.reject! do |path|
      if update_package_idx = path.index("Tengineコアパッケージのロールバック")
        shutdown_tengine = false
        if shutdown_tengine_idx = path.index("Tengineプロセスの停止") 
          update_package_idx < shutdown_tengine_idx
        else
          true
        end
      else
        false
      end
    end
    
    # DBサービスの起動を行わないとDBのリストア以外のDB操作(DBのリストア,DBのロールバック、DBのマイグレーション、DBのリカバリ)は行なうことができない
    # DBサービスの停止を行った場合は、その後にDBサービスの起動を行なう
    # DBサービスの停止、DBサービスの起動のあとにDB操作(DBのロールバック、DBのマイグレーション、DBのリカバリ)を行うことはない #追記ルールから外します
    results.reject! do |path| 
      if shutdown_idx = path.index("DBサービスの停止")
        if launch_idx = path.index("DBサービスの起動")
          restore_flg = rollback_flg = migration_flg = recovery_flg = false
          if restore = path.index("DBのリストア") 
            restore_flg =  (shutdown_idx < restore && restore < launch_idx) 
          end 
          if rollback = path.index("DBのロールバック") 
            rollback_flg =  (shutdown_idx < rollback && rollback < launch_idx) 
          end 
          if migration = path.index("DBのマイグレーション") 
            migration_flg = (shutdown_idx < migration && migration < launch_idx) 
          end 
          if recovry = path.index("DBのリカバリ")
            recovry_flg = (shutdown_idx < recovry && recovry < launch_idx) 
          end 
          restore_flg || rollback_flg || migration_flg || recovry_flg || shutdown_idx > launch_idx
        else
          true
        end
      else
        false
      end
    end
    
    # 開始時点でDBが起動していない場合、DBサービスの起動を行なう前に、DB操作(DBのリストア,DBのロールバック、DBのマイグレーション、DBのリカバリ)を行なうことはできない
    results.reject! do |path|
      if launch_db_idx = path.index("DBサービスの起動")
        if path.index("DBサービスの停止")==nil
          restore_flg = rollback_flg = migration_flg = recovery_flg = false

          if restore = path.index("DBのリストア")
            restore_flg = restore < launch_db_idx
          end
          
          if rollback = path.index("DBのロールバック")
            rollback_flg = rollback < launch_db_idx
          end
          
          if migration = path.index("DBのマイグレーション")
            migration_flg = migration < launch_db_idx
          end
          
          if recovry = path.index("DBのリカバリ")
            recovry_flg = recovry < launch_db_idx
          end
          
          restore_flg || rollback_flg || migration_flg || recovry_flg
        end
      else
        false
      end
    end
    
    
    # パッケージの更新・パッケージのロールバックを最後に行なうことはない
    results.reject! do |path|
      path.last =~ /パッケージ*/
    end
    
    # DBサービスの起動を行った場合は、その後にTengineプロセスの起動を行なう
    results.reject! do |path|
      if launch_db_idx = path.index("DBサービスの起動")
        if launch_tengine_idx = path.index("Tengineプロセスの起動")
          launch_tengine_idx < launch_db_idx
        else
          true
        end
      else
        false
      end
    end
    
    # DB操作(DBのロールバック、DBのマイグレーション、DBのリカバリ)を2回だけ行なうことはない
    results.reject! do |path|
      if (path.count("DBのマイグレーション") + path.count("DBのリカバリ") + path.count("DBのロールバック") == 2)
        true
      else
        false
      end
    end
    
    # イベントドライバの無効化とイベントドライバの有効化は無効化→有効化の順序で連続して行う
    results.reject! do |path|
      if event_driver_disabled_idx = path.index("イベントドライバの無効化")
        if event_driver_enabled_idx = path.index("イベントドライバの有効化")
          event_driver_disabled_idx + 1 != event_driver_enabled_idx 
        else
          false
        end
      else
        false
      end
    end
    
    # イベントハンドラ定義のデプロイとイベントハンドラ定義のロールバックを同時に行うことはない
    # ※展開時に処理をおこうなうことにした
    #result.reject! do |path|
    #  path.index("パッケージのロールバック") && path.index("パッケージの更新")
    #end
    
    # DBのマイグレーションを行なうときは前にTengineコアパッケージの更新を行う
    results.reject! do |path|
      if db_migration_idx = path.index("DBのマイグレーション")
        if package_update_idx = path.index("Tengineコアパッケージの更新")
          db_migration_idx < package_update_idx
        else
          true
        end
      else
        false
      end
    end
    
    # Tenginieプロセスの起動とイベントドライバの有効化／イベントドライバの無効化を行なうときは、イベントドライバの有効化／イベントドライバの無効化はTengineプロセスの起動前に行なう
    results.reject! do |path|
      if launch_idx = path.index("Tengineプロセスの起動")
        event_driver_enabled_idx = path.index("イベントドライバの有効化")
        event_driver_disabled_idx = path.index("イベントドライバの無効化")
        event_driver_disabled_flag = false
        event_driver_enabled_flag = false
        if event_driver_disabled_idx || event_driver_enabled_idx
          if event_driver_enabled_idx
            event_driver_enabled_flag = launch_idx < event_driver_enabled_idx
          end
          if event_driver_disabled_idx
            event_driver_disabled_flag = launch_idx < event_driver_disabled_idx
          end
          event_driver_disabled_flag || event_driver_enabled_flag
        else
          false
        end
      else
        false
      end
    end
    
    # Tengineプロセスの停止とTenginieプロセスの起動とイベントドライバの有効化／イベントドライバの無効化を行なうときは、イベントドライバの有効化／イベントドライバの無効化はTengineプロセスの停止とTengineプロセスの起動の間に行なう
    results.reject! do |path|
      if launch_idx = path.index("Tengineプロセスの起動")
        if shutdown_idx = path.index("Tengineプロセスの停止") 
          event_driver_enabled_idx = path.index("イベントドライバの有効化")
          event_driver_disabled_idx = path.index("イベントドライバの無効化")
          event_driver_disabled_flag = false
          event_driver_enabled_flag = false
          if event_driver_disabled_idx || event_driver_enabled_idx
            if event_driver_enabled_idx
              event_driver_enabled_flag = launch_idx < event_driver_enabled_idx || event_driver_enabled_idx < shutdown_idx
            end
            if event_driver_disabled_idx
              event_driver_disabled_flag = launch_idx < event_driver_disabled_idx || event_driver_disabled_idx < shutdown_idx
            end
            event_driver_disabled_flag || event_driver_enabled_flag
          else
            false
          end
        else
          false
        end
      else
        false
      end
    end
    
    # DBサービスの起動を行う前に、Tengineプロセスの停止を行なうことができない
    results.reject! do |path|
      if launch_db_idx = path.index("DBサービスの起動")
        if path.index("DBサービスの停止")==nil
          if shutdown_idx = path.index("Tengineプロセスの停止")
            shutdown_idx < launch_db_idx
          else
            false
          end
        else
          false 
        end
      else
        false
      end
    end
    
    # DBパッケージの更新とTengineコアパッケージの更新を行なうときは、DBパッケージの更新→Tengineコアパッケージの更新の順番で連続して行なう
    results.reject! do |path|
      if event_driver_disabled_idx = path.index("DBパッケージの更新")
        if event_driver_enabled_idx = path.index("Tengineコアパッケージの更新")
          event_driver_disabled_idx + 1 != event_driver_enabled_idx 
        else
          false
        end
      else
        false
      end
    end

    # DBパッケージの更新とTengineコアパッケージのロールバックを行なうときは、DBパッケージの更新→Tengineコアパッケージのロールバックの順番で連続して行なう
    results.reject! do |path|
      if event_driver_disabled_idx = path.index("DBパッケージの更新")
        if event_driver_enabled_idx = path.index("Tengineコアパッケージのロールバック")
          event_driver_disabled_idx + 1 != event_driver_enabled_idx 
        else
          false
        end
      else
        false
      end
    end

    # DBパッケージのロールバックとTengineコアパッケージの更新を行なうときは、DBパッケージのロールバック→Tengineコアパッケージの更新の順番で連続して行なう
    results.reject! do |path|
      if event_driver_disabled_idx = path.index("DBパッケージのロールバック")
        if event_driver_enabled_idx = path.index("Tengineコアパッケージの更新")
          event_driver_disabled_idx + 1 != event_driver_enabled_idx 
        else
          false
        end
      else
        false
      end
    end

    # DBパッケージの更新とTengineコアパッケージのロールバックを行なうときは、DBパッケージのロールバック→Tengineコアパッケージのロールバックの順番で連続して行なう
    results.reject! do |path|
      if event_driver_disabled_idx = path.index("DBパッケージのロールバック")
        if event_driver_enabled_idx = path.index("Tengineコアパッケージのロールバック")
          event_driver_disabled_idx + 1 != event_driver_enabled_idx 
        else
          false
        end
      else
        false
      end
    end

    # DBサービスの停止、DBサービスの起動がある場合、DBパッケージの更新・DBパッケージのロールバック・Tengineコアパッケージの更新・Tengineコアパッケージのロールバックは、DBサービスが停止中に行なう
    results.reject! do |path| 
      if shutdown_idx = path.index("DBサービスの停止")
        if launch_idx = path.index("DBサービスの起動")
          update_db_flg = rollback_db_flg = update_tengine_flg = rollback_tengine_flg = false
          if update_db = path.index("DBパッケージの更新") 
           update_db_flg =  !(shutdown_idx < update_db && update_db < launch_idx)
          end 
          if rollback_db = path.index("DBパッケージのロールバック") 
            rollback_db_flg = !(shutdown_idx < rollback_db && rollback_db < launch_idx)
          end 
          if update_tengine = path.index("Tengineコアパッケージの更新")
            update_tengine_flg = !(shutdown_idx < update_tengine && update_tengine < launch_idx)
          end 
          if rollback_tengine = path.index("Tengineコアパッケージのロールバック")
            rollback_tengine_flg = !(shutdown_idx < rollback_tengine && rollback_tengine < launch_idx)
          end 
          update_db_flg ||rollback_db_flg || update_tengine_flg || rollback_tengine_flg
        else
          true
        end
      else
        false
      end
    end

    # 開始時点でDBが起動していない場合、DBサービスの起動を行なう前に、DB操作(DBパッケージの更新、DBパッケージのロールバック、Tengineコアパッケージの更新,Tengineコアのロールバック)を行なうことはできない
    results.reject! do |path|
      if launch_db_idx = path.index("DBサービスの起動")
        if path.index("DBサービスの停止")==nil
          update_db_flg = rollback_db_flg = update_tengine_flg = rollback_tengine_flg = false
          if update_db = path.index("DBパッケージの更新") 
            update_db_flg =  update_db < launch_idx
          end 
          if rollback_db = path.index("DBパッケージのロールバック") 
            rollback_db_flg = rollback_db < launch_idx
          end 
          if update_tengine = path.index("Tengineコアパッケージの更新")
            update_tengine_flg = update_tengine < launch_idx
          end 
          if rollback_tengine = path.index("Tengineコアパッケージのロールバック")
            rollback_tengine_flg = rollback_tengine < launch_idx
          end 
          update_db_flg ||rollback_db_flg || update_tengine_flg || rollback_tengine_flg
        end
      else
        false
      end
    end

    # イベントハンドラ定義のデプロイと、イベントドライバの有効化を行う際は、イベントドライバの有効化は、イベントハンドラ定義のデプロイの後に行う。
    results.reject! do |path|
      if enable_idx = path.index("イベントドライバの有効化")
        if deploy_idx = path.index("イベントハンドラ定義のデプロイ")
          enable_idx < deploy_idx
        else
          false
        end
      else
        false
      end
    end

    #イベントハンドラ定義のデプロイと、イベントドライバの無効化を行う際は、イベントドライバの無効化は、イベントハンドラ定義のデプロイの後に行う。
    results.reject! do |path|
      if enable_idx = path.index("イベントドライバの無効化")
        if deploy_idx = path.index("イベントハンドラ定義のデプロイ")
          enable_idx < deploy_idx
        else
          false
        end
      else
        false
      end
    end

    #イベントハンドラ定義のロールバックと、イベントドライバの有効化を行う際は、イベントドライバの有効化は、イベントハンドラ定義のロールバックの後に行う。
    results.reject! do |path|
      if enable_idx = path.index("イベントドライバの有効化")
        if deploy_idx = path.index("イベントハンドラ定義のロールバック")
          enable_idx < deploy_idx
        else
          false
        end
      else
        false
      end
    end

    #イベントハンドラ定義のロールバックと、イベントドライバの無効化を行う際は、イベントドライバの無効化は、イベントハンドラ定義のロールバックの後に行う。
    results.reject! do |path|
      if enable_idx = path.index("イベントドライバの無効化")
        if deploy_idx = path.index("イベントハンドラ定義のロールバック")
          enable_idx < deploy_idx
        else
          false
        end
      else
        false
      end
    end

   #DBのバックアップ(物理ファイル)とDBパッケージの更新を行う際は、DBパッケージの更新は、DBのバックアップ(物理ファイル)の後に行う。
    results.reject! do |path|
      if update_idx = path.index("DBパッケージの更新")
        if backup_idx = path.index("DBのバックアップ(物理ファイル)")
          update_idx < backup_idx
        else
          false
        end
      else
        false
      end
    end

   #DBのバックアップ(物理ファイル)とDBパッケージのロールバックを行う際は、DBパッケージのロールバックは、DBのバックアップ(物理ファイル)の後に行う。
    results.reject! do |path|
      if update_idx = path.index("DBパッケージのロールバック")
        if backup_idx = path.index("DBのバックアップ(物理ファイル)")
          update_idx < backup_idx
        else
          false
        end
      else
        false
      end
    end

   #DBのバックアップ(物理ファイル)とTengineコアパッケージの更新を行う際は、Tengineコアパッケージの更新は、DBのバックアップ(物理ファイル)の後に行う。
    results.reject! do |path|
      if update_idx = path.index("Tengineコアパッケージの更新")
        if backup_idx = path.index("DBのバックアップ(物理ファイル)")
          update_idx < backup_idx
        else
          false
        end
      else
        false
      end
    end

   #DBのバックアップ(物理ファイル)とTengineコアパッケージのロールバックを行う際は、Tengineコアパッケージのロールバックは、DBのバックアップ(物理ファイル)の後に行う。
    results.reject! do |path|
      if update_idx = path.index("Tengineコアパッケージのロールバック")
        if backup_idx = path.index("DBのバックアップ(物理ファイル)")
          update_idx < backup_idx
        else
          false
        end
      else
        false
      end
    end

    #DBのリストアを行う場合は、Tengineプロセスの起動も行なわなければならない
    results.reject! do |path|
      if update_idx = path.index("DBのリストア")
        if backup_idx = path.index("Tengineプロセスの起動")
          false
        else
          true
        end
      else
        false
      end
    end

    #DBのリカバリを行う場合は、Tengineプロセスの起動も行なわなければならない
    results.reject! do |path|
      if update_idx = path.index("DBのリカバリ")
        if backup_idx = path.index("Tengineプロセスの起動")
          false
        else
          true
        end
      else
        false
      end
    end

    #DBのマイグレーションを行う場合は、Tengineプロセスの起動も行なわなければならない
    results.reject! do |path|
      if update_idx = path.index("DBのマイグレーション")
        if backup_idx = path.index("Tengineプロセスの起動")
          false
        else
          true
        end
      else
        false
      end
    end

    #DBのロールバックを行う場合は、Tengineプロセスの起動も行なわなければならない
    results.reject! do |path|
      if update_idx = path.index("DBのロールバック")
        if backup_idx = path.index("Tengineプロセスの起動")
          false
        else
          true
        end
      else
        false
      end
    end

    #DBのリストア(物理ファイル)を行う場合は、Tengineプロセスの起動も行なわなければならない
    results.reject! do |path|
      if update_idx = path.index("DBのリストア(物理ファイル)")
        if backup_idx = path.index("Tengineプロセスの起動")
          false
        else
          true
        end
      else
        false
      end
    end

    #DBのバックアップ(物理ファイル)を行う場合は、Tengineプロセスの起動も行なわなければならない
    results.reject! do |path|
      if update_idx = path.index("DBのバックアップ(物理ファイル)")
        if backup_idx = path.index("Tengineプロセスの起動")
          false
        else
          true
        end
      else
        false
      end
    end

    # 一時的な絞り込み
    #results.reject! do |path|
    #  (path.last =~ /Tengineプロセスの起動/)
    #end
    
    #pp results.sort
    #results.each do |path|
    # pp path if path.size == (ARGV[0]).to_i
    #end
    
#    results.each do |result|
#      puts result.join(",")
#    end
    
#    puts "total %d patterns" % results.length
    results
  end
  def get_prerequisites(path)
    prerequisite = []
     db_start_idx = path.index("DBサービスの起動")
     db_stop_idx = path.index("DBサービスの停止")
     tengine_start_idx = path.index("Tengineコアプロセスの起動")
     tengine_stop_idx = path.index("Tengineコアプロセスの停止")
     if db_start_idx && db_stop_idx
       prerequisite << "DBサービスが起動している"
     elsif db_start_idx
       prerequisite << "DBサービスが停止している"
     else
       prerequisite << "DBサービスが起動している"
     end

     if tengine_start_idx && tengine_stop_idx
       prerequisite << "Tengineコアプロセスサービスが起動している"
     elsif tengine_start_idx
       prerequisite << "Tengineコアプロセスサービスが停止している"
     else
       prerequisite << "Tengineコアプロセスサービスが起動している"
     end
     prerequisite
  end
end

results = Combination.new.result_node(ARGV[0])
results.each do |result|
  puts result.join(",")
end
puts "total %d patterns" % results.length
