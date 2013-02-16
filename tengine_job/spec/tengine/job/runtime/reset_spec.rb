# -*- coding: utf-8 -*-
require 'spec_helper'

describe "reset" do
  context "@4056" do
    before do
      pending "前提条件となるreset_spec/4056_1_dump.txtがかなり大きくて、新しいクラス構造への変更が大変なので後回し"
      @record = eval(File.read(File.expand_path("reset_spec/4056_1_dump.txt", File.dirname(__FILE__))))
      Tengine::Job::Runtime::Vertex.delete_all
      Tengine::Job::Runtime::Vertex.collection.insert(@record)
      @root = Tengine::Job::Runtime::Vertex.find(@record["_id"])
    end

    it "状況確認" do
      @root.phase_key.should == :error
      @root.element('/jn0006/jn1'                    ).phase_key.should == :error
      @root.element('/jn0006/jn1/jn11'               ).phase_key.should == :error
      @root.element('/jn0006/jn1/jn11/finally'       ).phase_key.should == :success
      @root.element('/jn0006/jn1/jn11/finally/jn11_f').phase_key.should == :success
      @root.element('/jn0006/jn1/j12'                ).phase_key.should == :initialized
      @root.element('/jn0006/jn1/finally'            ).phase_key.should == :success
      @root.element('/jn0006/jn1/finally/jn1_f'      ).phase_key.should == :success
      @root.element('/jn0006/jn2'                    ).phase_key.should == :initialized
      @root.element('/jn0006/jn2/j21'                ).phase_key.should == :initialized
      @root.element('/jn0006/jn2/jn22'               ).phase_key.should == :initialized
      @root.element('/jn0006/jn2/jn22/j221'          ).phase_key.should == :initialized
      @root.element('/jn0006/jn2/jn22/j222'          ).phase_key.should == :initialized
      @root.element('/jn0006/jn2/jn22/finally'       ).phase_key.should == :initialized
      @root.element('/jn0006/jn2/jn22/finally/jn22_f').phase_key.should == :initialized
      @root.element('/jn0006/jn2/finally'            ).phase_key.should == :initialized
      @root.element('/jn0006/jn2/finally/jn2_f'      ).phase_key.should == :initialized
      @root.element('/jn0006/finally'                ).phase_key.should == :success

      @root.edges.map(&:phase_key).should == [:transmitted, :closed, :closed]
      @root.element('/jn0006/jn1'             ).edges.map(&:phase_key).should == [:transmitted, :closed, :closed]
      @root.element('/jn0006/jn1/jn11'        ).edges.map(&:phase_key).should == [:transmitted, :closed, :closed]
      @root.element('/jn0006/jn1/jn11/finally').edges.map(&:phase_key).should == [:transmitted, :transmitted]
      @root.element('/jn0006/jn1/finally'     ).edges.map(&:phase_key).should == [:transmitted, :transmitted]
      @root.element('/jn0006/jn2'             ).edges.map(&:phase_key).should == [:active, :active, :active]
      @root.element('/jn0006/jn2/jn22'        ).edges.map(&:phase_key).should == [:active, :active, :active]
      @root.element('/jn0006/jn2/jn22/finally').edges.map(&:phase_key).should == [:active, :active]
      @root.element('/jn0006/jn2/finally'     ).edges.map(&:phase_key).should == [:active, :active]
      @root.element('/jn0006/finally'         ).edges.map(&:phase_key).should == [:transmitted, :transmitted]
    end

    it "jn11をspotで再実行" do
      @now = Time.now.utc
      @event = mock(:event, :occurred_at => @now)
      @signal = Tengine::Job::Runtime::Signal.new(@event)
      @jn11 = @root.element("jn11@jn1")
      @execution = Tengine::Job::Runtime::Execution.create!({
          :target_actual_ids => [@jn11.id.to_s],
          :retry => true, :spot => true,
          :root_jobnet_id => @root.id
        })
      @execution.phase_key.should == :initialized
      @event.stub(:[]).with(:execution_id).and_return(@execution.id.to_s)
      @execution.stub(:target_actuals).and_return([@jn11])

      @root.update_with_lock do
        @execution.transmit(@signal)
      end

      fire_args = @signal.reservations.first.fire_args
      fire_args.first.should == :"start.jobnet.job.tengine"
      hash = fire_args.last
      hash.delete(:source_name).should_not be_nil
      hash.should == {
        :properties => {
          :target_jobnet_id=>@jn11.id.to_s,
          :target_jobnet_name_path=>"/jn0006/jn1/jn11",
          :execution_id=>@execution.id.to_s,
          :root_jobnet_id=>@root.id.to_s,
          :root_jobnet_name_path=>"/jn0006"
        }
      }

      @root.reload
      @root.element('/jn0006/jn1'                    ).phase_key.should == :error
      @root.element('/jn0006/jn1/jn11'               ).phase_key.should == :ready
      @root.element('/jn0006/jn1/jn11/finally'       ).phase_key.should == :initialized
      @root.element('/jn0006/jn1/jn11/finally/jn11_f').phase_key.should == :initialized
      @root.element('/jn0006/jn1/j12'                ).phase_key.should == :initialized
      @root.element('/jn0006/jn1/finally'            ).phase_key.should == :success
      @root.element('/jn0006/jn1/finally/jn1_f'      ).phase_key.should == :success
      @root.element('/jn0006/jn2'                    ).phase_key.should == :initialized
      @root.element('/jn0006/jn2/j21'                ).phase_key.should == :initialized
      @root.element('/jn0006/jn2/jn22'               ).phase_key.should == :initialized
      @root.element('/jn0006/jn2/jn22/j221'          ).phase_key.should == :initialized
      @root.element('/jn0006/jn2/jn22/j222'          ).phase_key.should == :initialized
      @root.element('/jn0006/jn2/jn22/finally'       ).phase_key.should == :initialized
      @root.element('/jn0006/jn2/jn22/finally/jn22_f').phase_key.should == :initialized
      @root.element('/jn0006/jn2/finally'            ).phase_key.should == :initialized
      @root.element('/jn0006/jn2/finally/jn2_f'      ).phase_key.should == :initialized
      @root.element('/jn0006/finally'                ).phase_key.should == :success

      @root.edges.map(&:phase_key).should == [:transmitted, :closed, :closed]
      @root.element('/jn0006/jn1'             ).edges.map(&:phase_key).should == [:transmitted, :closed, :closed]
      @root.element('/jn0006/jn1/jn11'        ).edges.map(&:phase_key).should == [:active, :active, :active]
      @root.element('/jn0006/jn1/jn11/finally').edges.map(&:phase_key).should == [:active, :active]
      @root.element('/jn0006/jn1/finally'     ).edges.map(&:phase_key).should == [:transmitted, :transmitted]
      @root.element('/jn0006/jn2'             ).edges.map(&:phase_key).should == [:active, :active, :active]
      @root.element('/jn0006/jn2/jn22'        ).edges.map(&:phase_key).should == [:active, :active, :active]
      @root.element('/jn0006/jn2/jn22/finally').edges.map(&:phase_key).should == [:active, :active]
      @root.element('/jn0006/jn2/finally'     ).edges.map(&:phase_key).should == [:active, :active]
      @root.element('/jn0006/finally'         ).edges.map(&:phase_key).should == [:transmitted, :transmitted]
    end

    it "jn11以降を再実行" do
      @now = Time.now.utc
      @event = mock(:event, :occurred_at => @now)
      @signal = Tengine::Job::Runtime::Signal.new(@event)
      @jn11 = @root.element("jn11@jn1")
      @execution = Tengine::Job::Runtime::Execution.create!({
          :target_actual_ids => [@jn11.id.to_s],
          :retry => true, :spot => false,
          :root_jobnet_id => @root.id
        })
      @execution.phase_key.should == :initialized
      @event.stub(:[]).with(:execution_id).and_return(@execution.id.to_s)
      @execution.stub(:target_actuals).and_return([@jn11])

      @root.update_with_lock do
        @execution.transmit(@signal)
      end

      fire_args = @signal.reservations.first.fire_args
      fire_args.first.should == :"start.jobnet.job.tengine"
      hash = fire_args.last
      hash.delete(:source_name).should_not be_nil
      hash.should == {
        :properties => {
          :target_jobnet_id=>@jn11.id.to_s,
          :target_jobnet_name_path=>"/jn0006/jn1/jn11",
          :execution_id=>@execution.id.to_s,
          :root_jobnet_id=>@root.id.to_s,
          :root_jobnet_name_path=>"/jn0006"
        }
      }

      @root.reload
      @root.element('/jn0006/jn1'                    ).phase_key.should == :error
      @root.element('/jn0006/jn1/jn11'               ).phase_key.should == :ready
      @root.element('/jn0006/jn1/jn11/finally'       ).phase_key.should == :initialized
      @root.element('/jn0006/jn1/jn11/finally/jn11_f').phase_key.should == :initialized
      @root.element('/jn0006/jn1/j12'                ).phase_key.should == :initialized
      @root.element('/jn0006/jn1/finally'            ).phase_key.should == :initialized
      @root.element('/jn0006/jn1/finally/jn1_f'      ).phase_key.should == :initialized
      @root.element('/jn0006/jn2'                    ).phase_key.should == :initialized
      @root.element('/jn0006/jn2/j21'                ).phase_key.should == :initialized
      @root.element('/jn0006/jn2/jn22'               ).phase_key.should == :initialized
      @root.element('/jn0006/jn2/jn22/j221'          ).phase_key.should == :initialized
      @root.element('/jn0006/jn2/jn22/j222'          ).phase_key.should == :initialized
      @root.element('/jn0006/jn2/jn22/finally'       ).phase_key.should == :initialized
      @root.element('/jn0006/jn2/jn22/finally/jn22_f').phase_key.should == :initialized
      @root.element('/jn0006/jn2/finally'            ).phase_key.should == :initialized
      @root.element('/jn0006/jn2/finally/jn2_f'      ).phase_key.should == :initialized
      @root.element('/jn0006/finally'                ).phase_key.should == :success

      @root.edges.map(&:phase_key).should == [:transmitted, :closed, :closed]
      @root.element('/jn0006/jn1'             ).edges.map(&:phase_key).should == [:transmitted, :active, :active]
      @root.element('/jn0006/jn1/jn11'        ).edges.map(&:phase_key).should == [:active, :active, :active]
      @root.element('/jn0006/jn1/jn11/finally').edges.map(&:phase_key).should == [:active, :active]
      @root.element('/jn0006/jn1/finally'     ).edges.map(&:phase_key).should == [:active, :active]
      @root.element('/jn0006/jn2'             ).edges.map(&:phase_key).should == [:active, :active, :active]
      @root.element('/jn0006/jn2/jn22'        ).edges.map(&:phase_key).should == [:active, :active, :active]
      @root.element('/jn0006/jn2/jn22/finally').edges.map(&:phase_key).should == [:active, :active]
      @root.element('/jn0006/jn2/finally'     ).edges.map(&:phase_key).should == [:active, :active]
      @root.element('/jn0006/finally'         ).edges.map(&:phase_key).should == [:transmitted, :transmitted]
    end
  end

  # in [jn0005]
  #                         |--e3-->(j2)--e5--->|
  # (S1)--e1-->(j1)--e2-->[F1]                [J1]-->e7-->(j4)--e8-->(E1)
  #                         |--e4-->[jn4]--e6-->|
  #
  # in [jn0005/jn4]
  #                          |--e11-->(j42)--e13-->|
  # (S2)--e9-->(j41)--e10-->[F2]                  [J2]--e15-->(j44)--e16-->(E2)
  #                          |--e12-->(j43)--e14-->|
  #
  # in [jn0005/jn4/finally]
  # (S3)--e17-->(jn4_f)--e18-->(E3)
  #
  # in [jn0005/finally]
  # (S4)--e19-->[jn0005_fjn]--e20-->(jn0005_f)--e21-->(E4)
  #
  # in [jn0005/finally/jn0005_fjn]
  # (S5)--e22-->(jn0005_f1)--e23-->(jn0005_f1)--e24-->(E5)
  #
  # in [jn0005/finally/jn0005_fjn/finally]
  # (S6)--e25-->(jn0005_fif)--e26-->(E6)
  {
    "@4026" => true,
    "@4034" => false,
  }.each do |scenario_no, spot|
    context "#{scenario_no} スポット実行#{spot}" do
      before do
        Tengine::Job::Runtime::Vertex.delete_all
        builder = Rjn0005RetryTwoLayerFixture.new
        @root = builder.create_actual
        @ctx = builder.context
      end

      context "/jn0005/j1が:errorになって実行が終了した後" do
        before do
          @ctx[:jn0005].phase_key = :error
          @ctx[:j1].phase_key = :error
          @ctx[:jn0005].finally_vertex do |f|
            f.phase_key = :success
            f.descendants.each{|d| d.phase_key = :success}
          end
          @ctx[:e1].phase_key = :transmitted
          (2..8).each{|idx| @ctx[:"e#{idx}"].phase_key = :closed}
          (19..26).each{|idx| @ctx[:"e#{idx}"].phase_key = :transmitted}

          @root.save_descendants!
        end

        it "/jn0005/jn4/j41を再実行できる" do
          execution = Tengine::Job::Runtime::Execution.create!({
              :retry => true, :spot => spot,
              :root_jobnet_id => @root.id,
              :target_actual_ids => [@ctx[:j41].id.to_s]
            })
          execution.stub(:root_jobnet).and_return(@root)
          t1 = Time.now
          event1 = mock(:event1)
          event1.stub(:occurred_at).and_return(t1)
          signal1 = Tengine::Job::Runtime::Signal.new(event1)
          signal1.stub(:execution).and_return(execution)
          @root.update_with_lock do
            execution.transmit(signal1)
          end
          signal1.reservations.length.should == 1
          signal1.reservations.first.tap do |reservation|
            reservation.event_type_name.should == :"start.job.job.tengine"
          end
          #
          t2 = Time.now
          event2 = mock(:event2)
          event2.stub(:occurred_at).and_return(t2)
          signal2 = Tengine::Job::Runtime::Signal.new(event2)
          signal2.stub(:execution).and_return(execution)
          @root.reload
          j41 = @root.element("/jn0005/jn4/j41")
          j41.phase_key.should == :ready
          @root.update_with_lock do
            j41.activate(signal2)
          end
          signal2.reservations.map(&:fire_args).should == []
          signal2.reservations.length.should == 0
        end

      end
    end
  end

  context "@4035" do

    before do
      Tengine::Job::Runtime::Vertex.delete_all
      builder = Rjn0005RetryTwoLayerFixture.new
      @root = builder.create_actual
      @ctx = builder.context
    end

    context "/jn0005/j1が:errorになって実行が終了した後、/jn0005/j2を再実行" do
      before do
        @ctx[:jn0005].phase_key = :error
        @ctx[:j1].phase_key = :error
        @ctx[:j2].phase_key = :success
        [2,3,4,6].each{|idx| @ctx[:"e#{idx}"].phase_key = :closed}
        [1].each{|idx| @ctx[:"e#{idx}"].phase_key = :transmitted}
        [5,7,8].each{|idx| @ctx[:"e#{idx}"].phase_key = :active}
        (9..26).each{|idx| @ctx[:"e#{idx}"].phase_key = :active}
        @root.save_descendants!
      end

      it "成功しても/jn0005/j4は実行されない" do
        execution = Tengine::Job::Runtime::Execution.create!({
            :retry => true, :spot => false,
            :root_jobnet_id => @root.id,
            :target_actual_ids => [@ctx[:j2].id.to_s]
          })
        execution.stub(:root_jobnet).and_return(@root)
        t1 = Time.now
        event1 = mock(:"success.job.job.tengine")
        event1.stub(:occurred_at).and_return(t1)
        signal1 = Tengine::Job::Runtime::Signal.new(event1)
        signal1.stub(:execution).and_return(execution)
        next_of_j2 = @root.element("next!j2")
        @root.update_with_lock do
          next_of_j2.transmit(signal1)
        end
        signal1.reservations.map(&:fire_args).should == []
        @root.reload
        @root.element("j2").tap{|j| j.phase_key.should == :success }
        @root.element("j4").tap{|j| j.phase_key.should == :initialized }
        @root.element("next!j2").phase_key.should == :transmitted
        @root.element("prev!j4").phase_key.should == :active
      end
    end

  end

  context "@4034 [bug]initializedのジョブネット内のジョブを起点として再実行すると、起点となるジョブの後続ジョブがactivateされた際に親のジョブネットにackを返してしまいTengine::Job::Runtime::Executable::PhaseError" do
    before do
      Tengine::Job::Runtime::Vertex.delete_all
      builder = Rjn0005RetryTwoLayerFixture.new
      @root = builder.create_actual
      @ctx = builder.context
    end

    context "/jn0005/jn4/j41を起点として再実行" do
      before do
        @execution = Tengine::Job::Runtime::Execution.create!({
          :retry => true, :spot => false,
          :root_jobnet_id => @root.id,
          :target_actual_ids => [@ctx[:j41].id.to_s]
        })
        @execution.stub(:root_jobnet).and_return(@root)

        @ctx[:e1].phase_key = :transmitted
        (2..9).each{|idx| @ctx[:"e#{idx}"].phase_key = :closed}
        (10..18).each{|idx| @ctx[:"e#{idx}"].phase_key = :active}
        (19..26).each{|idx| @ctx[:"e#{idx}"].phase_key = :transmitted}

        [:root, :jn0005, :j1, :j41].each{|j| @ctx[j].update_phase! :error }
        [:jn4, :j2, :j4,
         :j42, :j43, :j44, :jn4f, :jn4_f].each{|j| @ctx[j].update_phase!:initialized }

        [:finally, :jn0005_fjn, :jn0005_f, :jn0005_f1, :jn0005_f2,
         :jn0005_fjn_f, :jn0005_fif].each{|j| @ctx[j].update_phase!:success}

        @root.save_descendants!
      end

      it "j41の後続のジョブがactivateされる" do
        t1 = Time.now
        event1 = mock(:"success.job.job.tengine")
        event1.stub(:occurred_at).and_return(t1)
        signal1 = Tengine::Job::Runtime::Signal.new(event1)
        signal1.stub(:execution).and_return(@execution)
        signal1.remember_all(@root)
        next_of_j41 = @root.element("next!/jn0005/jn4/j41")
        @root.update_with_lock do
          next_of_j41.transmit(signal1)
        end
        signal1.reservations.length.should == 2
        signal1.reservations.map(&:event_type_name).should == [:"start.job.job.tengine", :"start.job.job.tengine"]
        signal1.changed_vertecs.each(&:save!)

        @root.reload
        @root.element("/jn0005/jn4/j42").tap{|j| j.phase_key.should == :ready }
        @root.element("/jn0005/jn4/j43").tap{|j| j.phase_key.should == :ready }
        @root.element("next!/jn0005/jn4/j41").tap{|j| j.reload; j.phase_key.should == :transmitted }
        @root.element("prev!/jn0005/jn4/j42").tap{|j| j.reload; j.phase_key.should == :transmitting }
        @root.element("prev!/jn0005/jn4/j43").tap{|j| j.reload; j.phase_key.should == :transmitting }

        t2 = Time.now
        event2 = mock(:"start.job.job.tengine")
        event2.stub(:occurred_at).and_return(t2)
        signal2 = Tengine::Job::Runtime::Signal.new(event2)
        signal2.stub(:execution).and_return(@execution)
        j42 = @root.element("/jn0005/jn4/j42")
        @root.update_with_lock do
          j42.activate(signal2)
        end
        @root.reload
        @root.element("/jn0005/jn4/j42").tap{|j| j.phase_key.should == :starting }
        @root.element("/jn0005/jn4"    ).tap{|j| j.phase_key.should == :initialized }
      end
    end
  end

  context "ジョブネット内のジョブネットまたはジョブを起点にリセット" do
    before do
      Tengine::Job::Runtime::Vertex.delete_all
      builder = Rjn0005RetryTwoLayerFixture.new
      @root = builder.create_actual
      @ctx = builder.context
    end

    context "ルートジョブネットが正常終了した後に" do
      before do
        [:root, :jn0005, :j1, :jn4, :j2, :j4,
         :j41, :j42, :j43, :j44, :jn4f, :jn4_f,
         :finally, :jn0005_fjn, :jn0005_f, :jn0005_f1, :jn0005_f2,
         :jn0005_fjn_f, :jn0005_fif].each{|j| @ctx[j].phase_key = :success}

        (1..26).each{|idx| @ctx[:"e#{idx}"].phase_key = :transmitted}
        @root.save_descendants!
      end

      context "j41を起点に再実行すると" do
        it "jn4内のVertexのみリセットされる" do
          t1 = Time.now
          event1 = mock(:event, :occurred_at => t1)
          signal1 = Tengine::Job::Runtime::Signal.new(event1)
          j41 = @root.element('/jn0005/jn4/j41')
          execution = Tengine::Job::Runtime::Execution.create!({
            :target_actual_ids => [j41.id.to_s],
            :retry => true, :spot => false,
            :root_jobnet_id => @root.id
          })
          execution.stub(:root_jobnet).and_return(@root)
          event1.stub(:[]).with(:execution_id).and_return(execution.id.to_s)
          @root.update_with_lock{ execution.transmit(signal1) }
          @root.save!
          execution.save!
          execution.reload
          @root.reload

          (10..16).each{|idx| @ctx[:"e#{idx}"].phase_key.should == :active}
          (17..18).each{|idx| @ctx[:"e#{idx}"].phase_key.should == :active}
          (19..26).each{|idx| @ctx[:"e#{idx}"].phase_key.should == :transmitted}
          (1..9).each{|idx| @ctx[:"e#{idx}"].phase_key.should == :transmitted}
          @root.element('/jn0005'                  ).phase_key.should == :success
          @root.element('/jn0005/j1'               ).phase_key.should == :success
          @root.element('/jn0005/j2'               ).phase_key.should == :success
          @root.element('/jn0005/jn4'              ).phase_key.should == :success
          @root.element('/jn0005/jn4/j41'          ).phase_key.should == :ready
          @root.element('/jn0005/jn4/j42'          ).phase_key.should == :initialized
          @root.element('/jn0005/jn4/j43'          ).phase_key.should == :initialized
          @root.element('/jn0005/jn4/j44'          ).phase_key.should == :initialized
          @root.element('/jn0005/jn4/finally'      ).phase_key.should == :initialized
          @root.element('/jn0005/jn4/finally/jn4_f').phase_key.should == :initialized
          @root.element('/jn0005/j4'               ).phase_key.should == :success
          @root.element('/jn0005/finally'                              ).phase_key.should == :success
          @root.element('/jn0005/finally/jn0005_fjn'                   ).phase_key.should == :success
          @root.element('/jn0005/finally/jn0005_fjn/jn0005_f1'         ).phase_key.should == :success
          @root.element('/jn0005/finally/jn0005_fjn/jn0005_f2'         ).phase_key.should == :success
          @root.element('/jn0005/finally/jn0005_f'                     ).phase_key.should == :success
          @root.element('/jn0005/finally/jn0005_fjn/finally'           ).phase_key.should == :success
          @root.element('/jn0005/finally/jn0005_fjn/finally/jn0005_fif').phase_key.should == :success
        end

        it "jn4内のジョブの処理が全部終わって、jn4をsucceedしてもignore" do
          [:j41, :j42, :j43, :j44, :jn4f, :jn4_f].each{|j| @ctx[j].phase_key = :success}
          (10..18).each{|idx| @ctx[:"e#{idx}"].phase_key = :transmitted}
          @root.save_descendants!

          j41 = @root.element("j41@jn4")
          execution = Tengine::Job::Runtime::Execution.create!({
            :target_actual_ids => [j41.id.to_s],
            :retry => true, :spot => false,
            :root_jobnet_id => @root.id
          })

          t2 = Time.now
          # jn4fのジョブネット正常終了イベント
          event2 = mock(:"success.jobnet.job.tengine")
          event2.stub(:occurred_at).and_return(t2)
          signal2 = Tengine::Job::Runtime::Signal.new(event2)
          signal2.stub(:execution).and_return(execution)
          jn4 = @root.element('/jn0005/jn4')
          jn4.phase_key.should == :success
          jn4.finished_at.should be_nil
          @root.update_with_lock{ jn4.succeed(signal2) }

          @root.reload
          @root.element('/jn0005/j1'               ).phase_key.should == :success
          @root.element('/jn0005/j2'               ).phase_key.should == :success
          @root.element('/jn0005/jn4'              ).phase_key.should == :success
          @root.element('/jn0005/jn4'              ).finished_at.should be_nil
          @root.element('/jn0005/jn4/j41'          ).phase_key.should == :success
          @root.element('/jn0005/jn4/j42'          ).phase_key.should == :success
          @root.element('/jn0005/jn4/j43'          ).phase_key.should == :success
          @root.element('/jn0005/jn4/j44'          ).phase_key.should == :success
          @root.element('/jn0005/jn4/finally'      ).phase_key.should == :success
          @root.element('/jn0005/jn4/finally/jn4_f').phase_key.should == :success
          @root.element('/jn0005/j4'               ).phase_key.should == :success
          @root.element('/jn0005/finally'                              ).phase_key.should == :success
          @root.element('/jn0005/finally/jn0005_fjn'                   ).phase_key.should == :success
          @root.element('/jn0005/finally/jn0005_fjn/jn0005_f1'         ).phase_key.should == :success
          @root.element('/jn0005/finally/jn0005_fjn/jn0005_f2'         ).phase_key.should == :success
          @root.element('/jn0005/finally/jn0005_f'                     ).phase_key.should == :success
          @root.element('/jn0005/finally/jn0005_fjn/finally'           ).phase_key.should == :success
          @root.element('/jn0005/finally/jn0005_fjn/finally/jn0005_fif').phase_key.should == :success
        end
      end

      context "jn4を起点に再実行すると" do
        it "jn0005内のjn4以降がリセットされる" do
          t1 = Time.now
          event1 = mock(:event, :occurred_at => t1)
          signal1 = Tengine::Job::Runtime::Signal.new(event1)
          jn4 = @root.element('/jn0005/jn4')
          execution = Tengine::Job::Runtime::Execution.create!({
            :target_actual_ids => [jn4.id.to_s],
            :retry => true, :spot => false,
            :root_jobnet_id => @root.id
          })
          execution.stub(:root_jobnet).and_return(@root)
          event1.stub(:[]).with(:execution_id).and_return(execution.id.to_s)
          @root.update_with_lock{ execution.transmit(signal1) }
          @root.save!
          execution.save!
          execution.reload
          @root.reload

          (1..5).each{|idx|  @ctx[:"e#{idx}"].phase_key.should == :transmitted}
          (6..26).each{|idx| @ctx[:"e#{idx}"].phase_key.should == :active}
          @root.element('/jn0005'                  ).phase_key.should == :success
          @root.element('/jn0005/j1'               ).phase_key.should == :success
          @root.element('/jn0005/j2'               ).phase_key.should == :success
          @root.element('/jn0005/jn4'              ).phase_key.should == :ready
          @root.element('/jn0005/jn4/j41'          ).phase_key.should == :initialized
          @root.element('/jn0005/jn4/j42'          ).phase_key.should == :initialized
          @root.element('/jn0005/jn4/j43'          ).phase_key.should == :initialized
          @root.element('/jn0005/jn4/j44'          ).phase_key.should == :initialized
          @root.element('/jn0005/jn4/finally'      ).phase_key.should == :initialized
          @root.element('/jn0005/jn4/finally/jn4_f').phase_key.should == :initialized
          @root.element('/jn0005/j4'               ).phase_key.should == :initialized
          @root.element('/jn0005/finally'                              ).phase_key.should == :initialized
          @root.element('/jn0005/finally/jn0005_fjn'                   ).phase_key.should == :initialized
          @root.element('/jn0005/finally/jn0005_fjn/jn0005_f1'         ).phase_key.should == :initialized
          @root.element('/jn0005/finally/jn0005_fjn/jn0005_f2'         ).phase_key.should == :initialized
          @root.element('/jn0005/finally/jn0005_f'                     ).phase_key.should == :initialized
          @root.element('/jn0005/finally/jn0005_fjn/finally'           ).phase_key.should == :initialized
          @root.element('/jn0005/finally/jn0005_fjn/finally/jn0005_fif').phase_key.should == :initialized
        end
      end

      context "finally内のジョブjn0005_fifを起点に再実行すると" do
        it "/jn0005/finally/jn0005_fjn/finally内のVertexのみリセットされる" do
          t1 = Time.now
          event1 = mock(:event, :occurred_at => t1)
          signal1 = Tengine::Job::Runtime::Signal.new(event1)
          jn0005_fif = @root.element('/jn0005/finally/jn0005_fjn/finally/jn0005_fif')
          execution = Tengine::Job::Runtime::Execution.create!({
                        :target_actual_ids => [jn0005_fif.id.to_s],
                        :retry => true, :spot => false,
                        :root_jobnet_id => @root.id
                       })
          execution.stub(:root_jobnet).and_return(@root)
          event1.stub(:[]).with(:execution_id).and_return(execution.id.to_s)
          @root.update_with_lock{ execution.transmit(signal1) }
          @root.save!
          execution.save!
          execution.reload
          @root.reload

          @ctx[:e26].phase_key.should == :active
          @ctx[:e20].phase_key.should == :transmitted
          @ctx[:e21].phase_key.should == :transmitted
          (22..25).each{|idx| @ctx[:"e#{idx}"].phase_key.should == :transmitted}
          (1..19).each{|idx| @ctx[:"e#{idx}"].phase_key.should == :transmitted}
          @root.element('/jn0005/j1'               ).phase_key.should == :success
          @root.element('/jn0005/j2'               ).phase_key.should == :success
          @root.element('/jn0005/jn4'              ).phase_key.should == :success
          @root.element('/jn0005/jn4/j41'          ).phase_key.should == :success
          @root.element('/jn0005/jn4/j42'          ).phase_key.should == :success
          @root.element('/jn0005/jn4/j43'          ).phase_key.should == :success
          @root.element('/jn0005/jn4/j44'          ).phase_key.should == :success
          @root.element('/jn0005/jn4/finally'      ).phase_key.should == :success
          @root.element('/jn0005/jn4/finally/jn4_f').phase_key.should == :success
          @root.element('/jn0005/j4'               ).phase_key.should == :success
          @root.element('/jn0005/finally'                              ).phase_key.should == :success
          @root.element('/jn0005/finally/jn0005_fjn'                   ).phase_key.should == :success
          @root.element('/jn0005/finally/jn0005_fjn/jn0005_f1'         ).phase_key.should == :success
          @root.element('/jn0005/finally/jn0005_fjn/jn0005_f2'         ).phase_key.should == :success
          @root.element('/jn0005/finally/jn0005_f'                     ).phase_key.should == :success
          @root.element('/jn0005/finally/jn0005_fjn/finally'           ).phase_key.should == :success
          @root.element('/jn0005/finally/jn0005_fjn/finally/jn0005_fif').phase_key.should == :ready
        end
      end

      context "j1を起点に再実行すると" do
        before do
          j1 = @root.element('/jn0005/j1')
          @execution = Tengine::Job::Runtime::Execution.create!({
            :target_actual_ids => [j1.id.to_s],
            :retry => true, :spot => false,
            :root_jobnet_id => @root.id
          })
          t1 = Time.now
          event1 = mock(:event, :occurred_at => t1)
          signal1 = Tengine::Job::Runtime::Signal.new(event1)
          @execution.stub(:root_jobnet).and_return(@root)
          event1.stub(:[]).with(:execution_id).and_return(@execution.id.to_s)
          @root.update_with_lock{ @execution.transmit(signal1) }
          @root.save!
          @execution.save!
          @execution.reload
          @root.reload
        end

        it "リセット後の確認" do
          @execution.phase_key.should == :starting
          (2..26).each{|idx|  @ctx[:"e#{idx}"].phase_key.should == :active}
          [1].each{|idx| @ctx[:"e#{idx}"].phase_key.should == :transmitted}
          @root.element('/jn0005'                  ).phase_key.should == :success
          @root.element('/jn0005/j1'               ).phase_key.should == :ready
          @root.element('/jn0005/j2'               ).phase_key.should == :initialized
          @root.element('/jn0005/jn4'              ).phase_key.should == :initialized
          @root.element('/jn0005/jn4/j41'          ).phase_key.should == :initialized
          @root.element('/jn0005/jn4/j42'          ).phase_key.should == :initialized
          @root.element('/jn0005/jn4/j43'          ).phase_key.should == :initialized
          @root.element('/jn0005/jn4/j44'          ).phase_key.should == :initialized
          @root.element('/jn0005/jn4/finally'      ).phase_key.should == :initialized
          @root.element('/jn0005/jn4/finally/jn4_f').phase_key.should == :initialized
          @root.element('/jn0005/j4'               ).phase_key.should == :initialized
          @root.element('/jn0005/finally'                              ).phase_key.should == :initialized
          @root.element('/jn0005/finally/jn0005_fjn'                   ).phase_key.should == :initialized
          @root.element('/jn0005/finally/jn0005_fjn/jn0005_f1'         ).phase_key.should == :initialized
          @root.element('/jn0005/finally/jn0005_fjn/jn0005_f2'         ).phase_key.should == :initialized
          @root.element('/jn0005/finally/jn0005_f'                     ).phase_key.should == :initialized
          @root.element('/jn0005/finally/jn0005_fjn/finally'           ).phase_key.should == :initialized
          @root.element('/jn0005/finally/jn0005_fjn/finally/jn0005_fif').phase_key.should == :initialized
        end

        it "jn4内のジョブがactivateされるとjn4にack" do
          t2 = Time.now
          event2 = mock(:"start.job.job.tengine") # j41のジョブ開始イベント
          event2.stub(:occurred_at).and_return(t2)
          signal2 = Tengine::Job::Runtime::Signal.new(event2)
          signal2.stub(:execution).and_return(@execution)

          @root.element('/jn0005/jn4').phase_key = :starting
          j41 = @root.element('/jn0005/jn4/j41')
          j41.phase_key = :ready
          @root.save_descendants!
          @root.update_with_lock{ j41.activate(signal2) }
          @root.reload
          @root.element('/jn0005/jn4').phase_key.should == :running
        end

        it "/jn0005/jn4/finally/jn4_fがactivateされると/jn0005/jn4/finallyにack" do
          t2 = Time.now
          event2 = mock(:"start.job.job.tengine") # jn4fのジョブ開始イベント
          event2.stub(:occurred_at).and_return(t2)
          signal2 = Tengine::Job::Runtime::Signal.new(event2)
          signal2.stub(:execution).and_return(@execution)

          @root.element('/jn0005/jn4/finally').phase_key = :starting
          jn4_f = @root.element('/jn0005/jn4/finally/jn4_f')
          jn4_f.phase_key = :ready
          @root.save_descendants!
          @root.update_with_lock{ jn4_f.activate(signal2) }
          @root.reload
          @root.element('/jn0005/jn4/finally').phase_key.should == :running
        end

        it "/jn0005/finally/jn0005_fjn/finally/jn0005_fifがactivateされると/jn0005/finally/jn0005_fjn/finallyにack" do
          t2 = Time.now
          event2 = mock(:"start.job.job.tengine") # jn0005_fifのジョブ開始イベント
          event2.stub(:occurred_at).and_return(t2)
          signal2 = Tengine::Job::Runtime::Signal.new(event2)
          signal2.stub(:execution).and_return(@execution)

          @root.element('/jn0005/finally/jn0005_fjn/finally').phase_key = :starting
          jn0005_fif = @root.element('/jn0005/finally/jn0005_fjn/finally/jn0005_fif')
          jn0005_fif.phase_key = :ready
          @root.save_descendants!
          @root.update_with_lock{ jn0005_fif.activate(signal2) }
          @root.reload
          @root.element('/jn0005/finally/jn0005_fjn/finally').phase_key.should == :running
        end
      end
    end

    context "ジョブ/jn0005/jn4/j43が異常終了した後に" do
      before do
        [:root, :jn0005, :jn4, :j43].each{|j| @ctx[j].phase_key = :error}
        [:j4, :j44].each{|j| @ctx[j].phase_key = :initialized}
        [:j1, :j2, :j41, :j42,
         :jn4f, :jn4_f,
         :finally, :jn0005_fjn, :jn0005_f, :jn0005_f1, :jn0005_f2,
         :jn0005_fjn_f, :jn0005_fif].each{|j| @ctx[j].phase_key = :success}

        (1..5).each{|idx|   @ctx[:"e#{idx}"].phase_key = :transmitted}
        (6..8).each{|idx|   @ctx[:"e#{idx}"].phase_key = :closed}
        (9..13).each{|idx|  @ctx[:"e#{idx}"].phase_key = :transmitted}
        (14..16).each{|idx| @ctx[:"e#{idx}"].phase_key = :closed}
        (17..26).each{|idx| @ctx[:"e#{idx}"].phase_key = :transmitted}
        @root.save_descendants!
      end

      context "j43を起点に再実行すると" do
        it "jn4内のj43以降がリセットされる" do
          t1 = Time.now
          event1 = mock(:event, :occurred_at => t1)
          signal1 = Tengine::Job::Runtime::Signal.new(event1)
          j43 = @root.element('/jn0005/jn4/j43')
          execution = Tengine::Job::Runtime::Execution.create!({
            :target_actual_ids => [j43.id.to_s],
            :retry => true, :spot => false,
            :root_jobnet_id => @root.id
          })
          execution.stub(:root_jobnet).and_return(@root)
          event1.stub(:[]).with(:execution_id).and_return(execution.id.to_s)
          @root.update_with_lock{ execution.transmit(signal1) }
          @root.save!
          execution.save!
          execution.reload
          @root.reload

          (1..5).each{|idx|   @ctx[:"e#{idx}"].phase_key.should == :transmitted}
          (6..8).each{|idx|   @ctx[:"e#{idx}"].phase_key.should == :closed}
          (9..13).each{|idx|  @ctx[:"e#{idx}"].phase_key.should == :transmitted}
          (14..18).each{|idx| @ctx[:"e#{idx}"].phase_key.should == :active}
          (19..26).each{|idx| @ctx[:"e#{idx}"].phase_key.should == :transmitted}
          @root.element('/jn0005'                  ).phase_key.should == :error
          @root.element('/jn0005/j1'               ).phase_key.should == :success
          @root.element('/jn0005/j2'               ).phase_key.should == :success
          @root.element('/jn0005/jn4'              ).phase_key.should == :error
          @root.element('/jn0005/jn4/j41'          ).phase_key.should == :success
          @root.element('/jn0005/jn4/j42'          ).phase_key.should == :success
          @root.element('/jn0005/jn4/j43'          ).phase_key.should == :ready
          @root.element('/jn0005/jn4/j44'          ).phase_key.should == :initialized
          @root.element('/jn0005/jn4/finally'      ).phase_key.should == :initialized
          @root.element('/jn0005/jn4/finally/jn4_f').phase_key.should == :initialized
          @root.element('/jn0005/j4'               ).phase_key.should == :initialized
          @root.element('/jn0005/finally'                              ).phase_key.should == :success
          @root.element('/jn0005/finally/jn0005_fjn'                   ).phase_key.should == :success
          @root.element('/jn0005/finally/jn0005_fjn/jn0005_f1'         ).phase_key.should == :success
          @root.element('/jn0005/finally/jn0005_fjn/jn0005_f2'         ).phase_key.should == :success
          @root.element('/jn0005/finally/jn0005_f'                     ).phase_key.should == :success
          @root.element('/jn0005/finally/jn0005_fjn/finally'           ).phase_key.should == :success
          @root.element('/jn0005/finally/jn0005_fjn/finally/jn0005_fif').phase_key.should == :success
        end
      end

      context "j44を起点に再実行すると" do
        it "jn4内のj44の後続のみリセットされる" do
          t1 = Time.now
          event1 = mock(:event, :occurred_at => t1)
          signal1 = Tengine::Job::Runtime::Signal.new(event1)
          j44 = @root.element('/jn0005/jn4/j44')
          execution = Tengine::Job::Runtime::Execution.create!({
            :target_actual_ids => [j44.id.to_s],
            :retry => true, :spot => false,
            :root_jobnet_id => @root.id
          })
          execution.stub(:root_jobnet).and_return(@root)
          event1.stub(:[]).with(:execution_id).and_return(execution.id.to_s)
          @root.update_with_lock{ execution.transmit(signal1) }
          @root.save!
          execution.save!
          execution.reload
          @root.reload

          (1..5).each{|idx|   @ctx[:"e#{idx}"].phase_key.should == :transmitted}
          (6..8).each{|idx|   @ctx[:"e#{idx}"].phase_key.should == :closed}
          (9..13).each{|idx|  @ctx[:"e#{idx}"].phase_key.should == :transmitted}
          (14..15).each{|idx| @ctx[:"e#{idx}"].phase_key.should == :closed}
          (16..18).each{|idx| @ctx[:"e#{idx}"].phase_key.should == :active}
          (19..26).each{|idx| @ctx[:"e#{idx}"].phase_key.should == :transmitted}
          @root.element('/jn0005'                  ).phase_key.should == :error
          @root.element('/jn0005/j1'               ).phase_key.should == :success
          @root.element('/jn0005/j2'               ).phase_key.should == :success
          @root.element('/jn0005/jn4'              ).phase_key.should == :error
          @root.element('/jn0005/jn4/j41'          ).phase_key.should == :success
          @root.element('/jn0005/jn4/j42'          ).phase_key.should == :success
          @root.element('/jn0005/jn4/j43'          ).phase_key.should == :error
          @root.element('/jn0005/jn4/j44'          ).phase_key.should == :ready
          @root.element('/jn0005/jn4/finally'      ).phase_key.should == :initialized
          @root.element('/jn0005/jn4/finally/jn4_f').phase_key.should == :initialized
          @root.element('/jn0005/j4'               ).phase_key.should == :initialized
          @root.element('/jn0005/finally'                              ).phase_key.should == :success
          @root.element('/jn0005/finally/jn0005_fjn'                   ).phase_key.should == :success
          @root.element('/jn0005/finally/jn0005_fjn/jn0005_f1'         ).phase_key.should == :success
          @root.element('/jn0005/finally/jn0005_fjn/jn0005_f2'         ).phase_key.should == :success
          @root.element('/jn0005/finally/jn0005_f'                     ).phase_key.should == :success
          @root.element('/jn0005/finally/jn0005_fjn/finally'           ).phase_key.should == :success
          @root.element('/jn0005/finally/jn0005_fjn/finally/jn0005_fif').phase_key.should == :success
        end
      end

      context "jn4を起点に再実行すると" do
        it "jn0005内のjn4以降がリセットされる" do
          t1 = Time.now
          event1 = mock(:event, :occurred_at => t1)
          signal1 = Tengine::Job::Runtime::Signal.new(event1)
          jn4 = @root.element('/jn0005/jn4')
          execution = Tengine::Job::Runtime::Execution.create!({
            :target_actual_ids => [jn4.id.to_s],
            :retry => true, :spot => false,
            :root_jobnet_id => @root.id
          })
          execution.stub(:root_jobnet).and_return(@root)
          event1.stub(:[]).with(:execution_id).and_return(execution.id.to_s)
          @root.update_with_lock{ execution.transmit(signal1) }
          @root.save!
          execution.save!
          execution.reload
          @root.reload

          (1..5).each{|idx|  @ctx[:"e#{idx}"].phase_key.should == :transmitted}
          (6..26).each{|idx| @ctx[:"e#{idx}"].phase_key.should == :active}
          @root.element('/jn0005'                  ).phase_key.should == :error
          @root.element('/jn0005/j1'               ).phase_key.should == :success
          @root.element('/jn0005/j2'               ).phase_key.should == :success
          @root.element('/jn0005/jn4'              ).phase_key.should == :ready
          @root.element('/jn0005/jn4/j41'          ).phase_key.should == :initialized
          @root.element('/jn0005/jn4/j42'          ).phase_key.should == :initialized
          @root.element('/jn0005/jn4/j43'          ).phase_key.should == :initialized
          @root.element('/jn0005/jn4/j44'          ).phase_key.should == :initialized
          @root.element('/jn0005/jn4/finally'      ).phase_key.should == :initialized
          @root.element('/jn0005/jn4/finally/jn4_f').phase_key.should == :initialized
          @root.element('/jn0005/j4'               ).phase_key.should == :initialized
          @root.element('/jn0005/finally'                              ).phase_key.should == :initialized
          @root.element('/jn0005/finally/jn0005_fjn'                   ).phase_key.should == :initialized
          @root.element('/jn0005/finally/jn0005_fjn/jn0005_f1'         ).phase_key.should == :initialized
          @root.element('/jn0005/finally/jn0005_fjn/jn0005_f2'         ).phase_key.should == :initialized
          @root.element('/jn0005/finally/jn0005_f'                     ).phase_key.should == :initialized
          @root.element('/jn0005/finally/jn0005_fjn/finally'           ).phase_key.should == :initialized
          @root.element('/jn0005/finally/jn0005_fjn/finally/jn0005_fif').phase_key.should == :initialized
        end
      end
    end

    context "finally内のジョブ/jn0005/finally/jn0005_fjn/jn0005_f2が異常終了した後に" do
      before do
        [:root, :jn0005,
         :finally, :jn0005_fjn, :jn0005_f2,].each{|j| @ctx[j].phase_key = :error}
        [:j1, :j2, :jn4, :j4,
         :j41, :j42, :j43, :j44,
         :jn4f, :jn4_f, :jn0005_f1,
         :jn0005_fjn_f, :jn0005_fif].each{|j| @ctx[j].phase_key = :success}
        [:jn0005_f].each{|j| @ctx[j].phase_key = :initialized}

        (1..19).each{|idx|  @ctx[:"e#{idx}"].phase_key = :transmitted}
        (20..21).each{|idx| @ctx[:"e#{idx}"].phase_key = :closed}
        (22..23).each{|idx| @ctx[:"e#{idx}"].phase_key = :transmitted}
        [24].each{|idx|     @ctx[:"e#{idx}"].phase_key = :closed}
        (25..26).each{|idx| @ctx[:"e#{idx}"].phase_key = :transmitted}
        @root.save_descendants!
      end

      context "jn0005_f2を起点に再実行すると" do
        it "jn0005_fjn内のjn0005_f2以降がリセットされる" do
          t1 = Time.now
          event1 = mock(:event, :occurred_at => t1)
          signal1 = Tengine::Job::Runtime::Signal.new(event1)
          jn0005_f2 = @root.element('/jn0005/finally/jn0005_fjn/jn0005_f2')
          execution = Tengine::Job::Runtime::Execution.create!({
            :target_actual_ids => [jn0005_f2.id.to_s],
            :retry => true, :spot => false,
            :root_jobnet_id => @root.id
          })
          execution.stub(:root_jobnet).and_return(@root)
          event1.stub(:[]).with(:execution_id).and_return(execution.id.to_s)
          @root.update_with_lock{ execution.transmit(signal1) }
          @root.save!
          execution.save!
          execution.reload
          @root.reload

          (1..19).each{|idx|  @ctx[:"e#{idx}"].phase_key.should == :transmitted}
          (20..21).each{|idx| @ctx[:"e#{idx}"].phase_key.should == :closed}
          (22..23).each{|idx| @ctx[:"e#{idx}"].phase_key.should == :transmitted}
          (24..26).each{|idx| @ctx[:"e#{idx}"].phase_key.should == :active}
          @root.element('/jn0005'                  ).phase_key.should == :error
          @root.element('/jn0005/j1'               ).phase_key.should == :success
          @root.element('/jn0005/j2'               ).phase_key.should == :success
          @root.element('/jn0005/jn4'              ).phase_key.should == :success
          @root.element('/jn0005/jn4/j41'          ).phase_key.should == :success
          @root.element('/jn0005/jn4/j42'          ).phase_key.should == :success
          @root.element('/jn0005/jn4/j43'          ).phase_key.should == :success
          @root.element('/jn0005/jn4/j44'          ).phase_key.should == :success
          @root.element('/jn0005/jn4/finally'      ).phase_key.should == :success
          @root.element('/jn0005/jn4/finally/jn4_f').phase_key.should == :success
          @root.element('/jn0005/j4'               ).phase_key.should == :success
          @root.element('/jn0005/finally'                              ).phase_key.should == :error
          @root.element('/jn0005/finally/jn0005_fjn'                   ).phase_key.should == :error
          @root.element('/jn0005/finally/jn0005_fjn/jn0005_f1'         ).phase_key.should == :success
          @root.element('/jn0005/finally/jn0005_fjn/jn0005_f2'         ).phase_key.should == :ready
          @root.element('/jn0005/finally/jn0005_f'                     ).phase_key.should == :initialized
          @root.element('/jn0005/finally/jn0005_fjn/finally'           ).phase_key.should == :initialized
          @root.element('/jn0005/finally/jn0005_fjn/finally/jn0005_fif').phase_key.should == :initialized
        end
      end

      context "jn0005_fjnを起点に再実行すると" do
        it "jn0005_fjn内がリセットされる" do
          t1 = Time.now
          event1 = mock(:event, :occurred_at => t1)
          signal1 = Tengine::Job::Runtime::Signal.new(event1)
          jn0005_fjn = @root.element('/jn0005/finally/jn0005_fjn')
          execution = Tengine::Job::Runtime::Execution.create!({
            :target_actual_ids => [jn0005_fjn.id.to_s],
            :retry => true, :spot => false,
            :root_jobnet_id => @root.id
          })
          execution.stub(:root_jobnet).and_return(@root)
          event1.stub(:[]).with(:execution_id).and_return(execution.id.to_s)
          @root.update_with_lock{ execution.transmit(signal1) }
          @root.save!
          execution.save!
          execution.reload
          @root.reload

          (1..19).each{|idx|  @ctx[:"e#{idx}"].phase_key.should == :transmitted}
          (20..26).each{|idx| @ctx[:"e#{idx}"].phase_key.should == :active}
          @root.element('/jn0005'                  ).phase_key.should == :error
          @root.element('/jn0005/j1'               ).phase_key.should == :success
          @root.element('/jn0005/j2'               ).phase_key.should == :success
          @root.element('/jn0005/jn4'              ).phase_key.should == :success
          @root.element('/jn0005/jn4/j41'          ).phase_key.should == :success
          @root.element('/jn0005/jn4/j42'          ).phase_key.should == :success
          @root.element('/jn0005/jn4/j43'          ).phase_key.should == :success
          @root.element('/jn0005/jn4/j44'          ).phase_key.should == :success
          @root.element('/jn0005/jn4/finally'      ).phase_key.should == :success
          @root.element('/jn0005/jn4/finally/jn4_f').phase_key.should == :success
          @root.element('/jn0005/j4'               ).phase_key.should == :success
          @root.element('/jn0005/finally'                              ).phase_key.should == :error
          @root.element('/jn0005/finally/jn0005_fjn'                   ).phase_key.should == :ready
          @root.element('/jn0005/finally/jn0005_fjn/jn0005_f1'         ).phase_key.should == :initialized
          @root.element('/jn0005/finally/jn0005_fjn/jn0005_f2'         ).phase_key.should == :initialized
          @root.element('/jn0005/finally/jn0005_f'                     ).phase_key.should == :initialized
          @root.element('/jn0005/finally/jn0005_fjn/finally'           ).phase_key.should == :initialized
          @root.element('/jn0005/finally/jn0005_fjn/finally/jn0005_fif').phase_key.should == :initialized
        end
      end

      context "jn0005/finallyを起点に再実行すると" do
        it "jn0005/finally内がリセットされる" do
          t1 = Time.now
          event1 = mock(:event, :occurred_at => t1)
          signal1 = Tengine::Job::Runtime::Signal.new(event1)
          finally = @root.element('/jn0005/finally')
          execution = Tengine::Job::Runtime::Execution.create!({
            :target_actual_ids => [finally.id.to_s],
            :retry => true, :spot => false,
            :root_jobnet_id => @root.id
          })
          execution.stub(:root_jobnet).and_return(@root)
          event1.stub(:[]).with(:execution_id).and_return(execution.id.to_s)
          @root.update_with_lock{ execution.transmit(signal1) }
          @root.save!
          execution.save!
          execution.reload
          @root.reload

          (1..18).each{|idx|  @ctx[:"e#{idx}"].phase_key.should == :transmitted}
          (19..26).each{|idx| @ctx[:"e#{idx}"].phase_key.should == :active}
          @root.element('/jn0005'                  ).phase_key.should == :error
          @root.element('/jn0005/j1'               ).phase_key.should == :success
          @root.element('/jn0005/j2'               ).phase_key.should == :success
          @root.element('/jn0005/jn4'              ).phase_key.should == :success
          @root.element('/jn0005/jn4/j41'          ).phase_key.should == :success
          @root.element('/jn0005/jn4/j42'          ).phase_key.should == :success
          @root.element('/jn0005/jn4/j43'          ).phase_key.should == :success
          @root.element('/jn0005/jn4/j44'          ).phase_key.should == :success
          @root.element('/jn0005/jn4/finally'      ).phase_key.should == :success
          @root.element('/jn0005/jn4/finally/jn4_f').phase_key.should == :success
          @root.element('/jn0005/j4'               ).phase_key.should == :success
          @root.element('/jn0005/finally'                              ).phase_key.should == :ready
          @root.element('/jn0005/finally/jn0005_fjn'                   ).phase_key.should == :initialized
          @root.element('/jn0005/finally/jn0005_fjn/jn0005_f1'         ).phase_key.should == :initialized
          @root.element('/jn0005/finally/jn0005_fjn/jn0005_f2'         ).phase_key.should == :initialized
          @root.element('/jn0005/finally/jn0005_f'                     ).phase_key.should == :initialized
          @root.element('/jn0005/finally/jn0005_fjn/finally'           ).phase_key.should == :initialized
          @root.element('/jn0005/finally/jn0005_fjn/finally/jn0005_fif').phase_key.should == :initialized
        end
      end
    end
  end
end
