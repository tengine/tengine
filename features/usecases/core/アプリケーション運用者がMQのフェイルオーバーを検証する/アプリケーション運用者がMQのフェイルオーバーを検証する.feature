#language:ja

@manual
��ǽ: ���ץꥱ��������ѼԤ�MQ�Υե����륪���С��򸡾ڤ��� [������]

  MQ�����Ф������󤷤��ݤˡ�
  ���ץꥱ��������Ѽ�
  �ϡ�MQ�����Ф��ե����륪���С����뤳�Ȥ򸡾ڤ�������

  @manual
  �ط�:

    ���� MQ������A��¸�ߤ��롣�����IP���ɥ쥹��zbtgnmq1�Ǥ���Ȥ���
    ���� MQ������B��¸�ߤ��롣�����IP���ɥ쥹��zbtgnmq2�Ǥ���Ȥ���
    ���� VIP�����åȥ��åפ���Ƥ���
    ���� tengined������ե������VIP�˥�����������褦�����ꤵ��Ƥ���

    ���� ���Υե������Ʊ���ǥ��쥯�ȥ�ˤ���dsl�ǥ��쥯�ȥ�� $dsl �ȸƤ֤��Ȥˤ���
    ���� MQ�Υ����ӥ���crm_resource�������/�Ƴ�������ˡ��Ĵ�٤Ƥ���
    ���� VIP�����/�Ƴ�������ˡ��Ĵ�٤Ƥ���
    ���� MQ�����Фβ��ۥޥ�������/�Ƴ�������ˡ��Ĵ�٤Ƥ���

  @manual
  ���ʥꥪ: [�۾��]tengined��ư����MQ�ץ����������󤷤��ݤ˥ե����륪���С�����

    ���� ���������о�� "/tmp/tmp.txt" �ե����뤬¸�ߤ��ʤ�����

    # MQ�����

    MQ�Υץ�������ߤ��뤿���Pacemaker����"sudo crm_resource -r MQ -p target-role -v stopped"��¹Ԥ��롣

    # 1����

    �⤷ "Tengine�����ץ���"�ε�ư��Ԥ������"tengined -T $dsl"�Ȥ������ޥ�ɤ�¹Ԥ���
    �ʤ�� tengined����ư���ʤ����Ȥ��ǧ���롣

    # MQ�κƵ�ư

    MQ�Υץ�����ư���뤿���Pacemaker����"sudo crm_resource -r MQ -p target-role -v started"��¹Ԥ��롣
    # rabbitmq-server����ư���Ƥ������Ȥ�ʤ�餫����ˡ�ǳ�ǧ����

    # 2����
    
    �⤷ "Tengine�����ץ���"�ε�ư��Ԥ������"tengined -T $dsl"�Ȥ������ޥ�ɤ�¹Ԥ���
    �⤷ "Tengine�����ץ���"��ɸ����Ϥ���PID���ǧ����
    �⤷ "Tengine�����ץ���"�ξ��֤�"��Ư��"�Ǥ��뤳�Ȥ��ǧ����

    �⤷ ���٥��ȯ�в��̤���"event_at_first"��ȯ�Ф���

    �ʤ�� �����ץ�������ư���������о�� "/tmp/tmp.txt" ��¸�ߤ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_at_first called" �Ƚ񤫤�Ƥ��뤳��


  @manual
  ���ʥꥪ: [�۾��]tengined��ư����MQ�����Ф������󤷤��ݤ˥ե����륪���С�����

    ���� ���������о�� "/tmp/tmp.txt" �ե����뤬¸�ߤ��ʤ�����

    # MQ�����

    VIP����ߤ��� # �ɤ���ä�?

    # 1����

    �⤷ "Tengine�����ץ���"�ε�ư��Ԥ������"tengined -T $dsl"�Ȥ������ޥ�ɤ�¹Ԥ���
    �ʤ�� tengined����ư���ʤ����Ȥ��ǧ���롣

    # MQ�����

    VIP��Ƶ�ư���� # �ɤ���ä�?

    # 2����
    
    �⤷ "Tengine�����ץ���"�ε�ư��Ԥ������"tengined -T $dsl"�Ȥ������ޥ�ɤ�¹Ԥ���
    �⤷ "Tengine�����ץ���"��ɸ����Ϥ���PID���ǧ����
    �⤷ "Tengine�����ץ���"�ξ��֤�"��Ư��"�Ǥ��뤳�Ȥ��ǧ����

    �⤷ ���٥��ȯ�в��̤���"event_at_first"��ȯ�Ф���

    �ʤ�� �����ץ�������ư���������о�� "/tmp/tmp.txt" ��¸�ߤ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_at_first called" �Ƚ񤫤�Ƥ��뤳��


  ################################################################################################################################################

  @manual
  ���ʥꥪ: [�۾��]���٥�ȼ����塢MQ�ץ����������󤷤��ݤ˥ե����륪���С�����(ack at_first)

    ���� VIP�����꤬zbtgnmq1������Ƥ��뤳��

    �⤷ "Tengine�����ץ���"�ε�ư��Ԥ������"tengined -T $dsl"�Ȥ������ޥ�ɤ�¹Ԥ���
    �⤷ "Tengine�����ץ���"��ɸ����Ϥ���PID���ǧ����
    �⤷ "Tengine�����ץ���"�ξ��֤�"��Ư��"�Ǥ��뤳�Ȥ��ǧ����

    # MQ����ߤ���Ƶ�ư

    # rabbitmq��ľ����Ȥ��ơ�Pacemaker�˺Ƶ�ư������
    �⤷ MQ�ץ�������ߤ��뤿��� zbtgnmq1�ˤ� "sudo rabbitmqctl stop"�Ȥ������ޥ�ɤ�¹Ԥ���
    �⤷ Pacemaker��MQ�ץ�����Ƶ�ư���Ƥ���Τ��ǧ���뤿��� "sudo rabbitmqctl status"�Ȥ������ޥ�ɤ�¹Ԥ���
    �ʤ�� '{running_applications,[{rabbit,"RabbitMQ",' �Ȥ������Ƥ�ޤ���Ϥ����뤳��

    # ���٥�ȼ¹�

    �⤷ ���٥��ȯ�в��̤���"event_at_first"��ȯ�Ф���

    �ʤ�� �����ץ�������ư���������о�� "/tmp/tmp.txt" ��¸�ߤ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_at_first called" �Ƚ񤫤�Ƥ��뤳��


  @manual
  ���ʥꥪ: [�۾��]���٥�������塢MQ�����Ф������󤷤��ݤ˥ե����륪���С�����(ack at_first)

    ���� VIP�����꤬zbtgnmq1������Ƥ��뤳��

    �⤷ "Tengine�����ץ���"�ε�ư��Ԥ������"tengined -T $dsl"�Ȥ������ޥ�ɤ�¹Ԥ���
    �⤷ "Tengine�����ץ���"��ɸ����Ϥ���PID���ǧ����
    �⤷ "Tengine�����ץ���"�ξ��֤�"��Ư��"�Ǥ��뤳�Ȥ��ǧ����

    # MQ����ߤ���Ƶ�ư

    �⤷ zbtgnmq1�β��ۥޥ������Ȥ�
    �⤷ VIP���ڤ��ؤ�ä�zbtgnmq2����������Ȥ��ǧ���� # ping�Ȥ�

    # 2����

    �⤷ ���٥��ȯ�в��̤���"event_at_first"��ȯ�Ф���

    �ʤ�� �����ץ�������ư���������о�� "/tmp/tmp.txt" ��¸�ߤ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_at_first called" �Ƚ񤫤�Ƥ��뤳��


  @manual
  ���ʥꥪ: [�۾��]���٥�ȼ����塢MQ�ץ����������󤷤��ݤ˥ե����륪���С�����(ack at_first)

    ���� VIP�����꤬zbtgnmq1������Ƥ��뤳��

    �⤷ "Tengine�����ץ���"�ε�ư��Ԥ������"tengined -T $dsl"�Ȥ������ޥ�ɤ�¹Ԥ���
    �⤷ "Tengine�����ץ���"��ɸ����Ϥ���PID���ǧ����
    �⤷ "Tengine�����ץ���"�ξ��֤�"��Ư��"�Ǥ��뤳�Ȥ��ǧ����

    # 1����

    �⤷ ���٥��ȯ�в��̤���"event_at_first"��ȯ�Ф���

    �ʤ�� �����ץ�������ư���������о�� "/tmp/tmp.txt" ��¸�ߤ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_at_first called" �Ƚ񤫤�Ƥ��뤳��

    # MQ����ߤ���Ƶ�ư

    �⤷ MQ�ץ�������ߤ��뤿��� zbtgnmq1�ˤ� "sudo rabbitmqctl stop"�Ȥ������ޥ�ɤ�¹Ԥ���
    �⤷ Pacemaker��MQ�ץ�����Ƶ�ư���Ƥ���Τ��ǧ���뤿��� "sudo rabbitmqctl status"�Ȥ������ޥ�ɤ�¹Ԥ���
    �ʤ�� '{running_applications,[{rabbit,"RabbitMQ",' �Ȥ������Ƥ�ޤ���Ϥ����뤳��

    # 2����

    �⤷ ���������о��"/tmp/tmp.txt"��������
    ���� ���٥��ȯ�в��̤���"event_at_first"��ȯ�Ф���

    �ʤ�� �����ץ�������ư���������о�� "/tmp/tmp.txt" ��¸�ߤ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_at_first called" �Ƚ񤫤�Ƥ��뤳��


  @manual
  ���ʥꥪ: [�۾��]���٥�������塢MQ�����Ф������󤷤��ݤ˥ե����륪���С�����(ack at_first)

    ���� VIP�����꤬zbtgnmq1������Ƥ��뤳��

    �⤷ "Tengine�����ץ���"�ε�ư��Ԥ������"tengined -T $dsl"�Ȥ������ޥ�ɤ�¹Ԥ���
    �⤷ "Tengine�����ץ���"��ɸ����Ϥ���PID���ǧ����
    �⤷ "Tengine�����ץ���"�ξ��֤�"��Ư��"�Ǥ��뤳�Ȥ��ǧ����

    # 1����

    �⤷ ���٥��ȯ�в��̤���"event_at_first"��ȯ�Ф���

    �ʤ�� �����ץ�������ư���������о�� "/tmp/tmp.txt" ��¸�ߤ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_at_first called" �Ƚ񤫤�Ƥ��뤳��

    # MQ����ߤ���Ƶ�ư

    �⤷ zbtgnmq1�β��ۥޥ������Ȥ�
    �⤷ VIP���ڤ��ؤ�ä�zbtgnmq2����������Ȥ��ǧ���� # ping�Ȥ�

    # 2����

    �⤷ ���������о��"/tmp/tmp.txt"��������
    ���� ���٥��ȯ�в��̤���"event_at_first"��ȯ�Ф���

    �ʤ�� �����ץ�������ư���������о�� "/tmp/tmp.txt" ��¸�ߤ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_at_first called" �Ƚ񤫤�Ƥ��뤳��


  ################################################################################################################################################

  # ���Τ�ư���ʤ����ʥꥪ
  @manual
  ���ʥꥪ: [�۾��]���٥�ȼ����塢MQ�ץ����������󤷤��ݤ˥ե����륪���С�����(ack at_first_submit)

    ���� VIP�����꤬zbtgnmq1������Ƥ��뤳��

    �⤷ "Tengine�����ץ���"�ε�ư��Ԥ������"tengined -T $dsl"�Ȥ������ޥ�ɤ�¹Ԥ���
    �⤷ "Tengine�����ץ���"��ɸ����Ϥ���PID���ǧ����
    �⤷ "Tengine�����ץ���"�ξ��֤�"��Ư��"�Ǥ��뤳�Ȥ��ǧ����

    # MQ����ߤ���Ƶ�ư

    �⤷ MQ�ץ�������ߤ��뤿��� zbtgnmq1�ˤ� "sudo rabbitmqctl stop"�Ȥ������ޥ�ɤ�¹Ԥ���
    �⤷ Pacemaker��MQ�ץ�����Ƶ�ư���Ƥ���Τ��ǧ���뤿��� "sudo rabbitmqctl status"�Ȥ������ޥ�ɤ�¹Ԥ���
    �ʤ�� '{running_applications,[{rabbit,"RabbitMQ",' �Ȥ������Ƥ�ޤ���Ϥ����뤳��

    # ���٥�ȼ¹�

    �⤷ ���٥��ȯ�в��̤���"event_at_first_submit"��ȯ�Ф���

    �ʤ�� �����ץ�������ư���������о�� "/tmp/tmp.txt" ��¸�ߤ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_at_first_submit1 called" �Ƚ񤫤�Ƥ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_at_first_submit2 called" �Ƚ񤫤�Ƥ��뤳��


  # ���Τ�ư���ʤ����ʥꥪ
  @manual
  ���ʥꥪ: [�۾��]���٥�������塢MQ�����Ф������󤷤��ݤ˥ե����륪���С�����(ack at_first_submit)

    ���� VIP�����꤬zbtgnmq1������Ƥ��뤳��

    �⤷ "Tengine�����ץ���"�ε�ư��Ԥ������"tengined -T $dsl"�Ȥ������ޥ�ɤ�¹Ԥ���
    �⤷ "Tengine�����ץ���"��ɸ����Ϥ���PID���ǧ����
    �⤷ "Tengine�����ץ���"�ξ��֤�"��Ư��"�Ǥ��뤳�Ȥ��ǧ����

    # MQ����ߤ���Ƶ�ư

    �⤷ zbtgnmq1�β��ۥޥ������Ȥ�
    �⤷ VIP���ڤ��ؤ�ä�zbtgnmq2����������Ȥ��ǧ���� # ping�Ȥ�

    # 2����

    �⤷ ���٥��ȯ�в��̤���"event_at_first_submit"��ȯ�Ф���

    �ʤ�� �����ץ�������ư���������о�� "/tmp/tmp.txt" ��¸�ߤ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_at_first_submit1 called" �Ƚ񤫤�Ƥ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_at_first_submit2 called" �Ƚ񤫤�Ƥ��뤳��


  # ���Τ�ư���ʤ����ʥꥪ
  @manual
  ���ʥꥪ: [�۾��]���٥�ȼ����塢MQ�ץ����������󤷤��ݤ˥ե����륪���С�����(ack at_first_submit)

    ���� VIP�����꤬zbtgnmq1������Ƥ��뤳��

    �⤷ "Tengine�����ץ���"�ε�ư��Ԥ������"tengined -T $dsl"�Ȥ������ޥ�ɤ�¹Ԥ���
    �⤷ "Tengine�����ץ���"��ɸ����Ϥ���PID���ǧ����
    �⤷ "Tengine�����ץ���"�ξ��֤�"��Ư��"�Ǥ��뤳�Ȥ��ǧ����

    # 1����

    �⤷ ���٥��ȯ�в��̤���"event_at_first_submit"��ȯ�Ф���

    �ʤ�� �����ץ�������ư���������о�� "/tmp/tmp.txt" ��¸�ߤ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_at_first_submit1 called" �Ƚ񤫤�Ƥ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_at_first_submit2 called" �Ƚ񤫤�Ƥ��뤳��

    # MQ����ߤ���Ƶ�ư

    �⤷ MQ�ץ�������ߤ��뤿��� zbtgnmq1�ˤ� "sudo rabbitmqctl stop"�Ȥ������ޥ�ɤ�¹Ԥ���
    �⤷ Pacemaker��MQ�ץ�����Ƶ�ư���Ƥ���Τ��ǧ���뤿��� "sudo rabbitmqctl status"�Ȥ������ޥ�ɤ�¹Ԥ���
    �ʤ�� '{running_applications,[{rabbit,"RabbitMQ",' �Ȥ������Ƥ�ޤ���Ϥ����뤳��

    # 2����

    �⤷ ���������о��"/tmp/tmp.txt"��������
    ���� ���٥��ȯ�в��̤���"event_at_first_submit"��ȯ�Ф���

    �ʤ�� �����ץ�������ư���������о�� "/tmp/tmp.txt" ��¸�ߤ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_at_first_submit1 called" �Ƚ񤫤�Ƥ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_at_first_submit2 called" �Ƚ񤫤�Ƥ��뤳��


  # ���Τ�ư���ʤ����ʥꥪ
  @manual
  ���ʥꥪ: [�۾��]���٥�������塢MQ�����Ф������󤷤��ݤ˥ե����륪���С�����(ack at_first_submit)

    ���� VIP�����꤬zbtgnmq1������Ƥ��뤳��

    �⤷ "Tengine�����ץ���"�ε�ư��Ԥ������"tengined -T $dsl"�Ȥ������ޥ�ɤ�¹Ԥ���
    �⤷ "Tengine�����ץ���"��ɸ����Ϥ���PID���ǧ����
    �⤷ "Tengine�����ץ���"�ξ��֤�"��Ư��"�Ǥ��뤳�Ȥ��ǧ����

    # 1����

    �⤷ ���٥��ȯ�в��̤���"event_at_first_submit"��ȯ�Ф���

    �ʤ�� �����ץ�������ư���������о�� "/tmp/tmp.txt" ��¸�ߤ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_at_first_submit1 called" �Ƚ񤫤�Ƥ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_at_first_submit2 called" �Ƚ񤫤�Ƥ��뤳��

    # MQ����ߤ���Ƶ�ư

    �⤷ zbtgnmq1�β��ۥޥ������Ȥ�
    �⤷ VIP���ڤ��ؤ�ä�zbtgnmq2����������Ȥ��ǧ���� # ping�Ȥ�

    # 2����

    �⤷ ���������о��"/tmp/tmp.txt"��������
    ���� ���٥��ȯ�в��̤���"event_at_first_submit"��ȯ�Ф���

    �ʤ�� �����ץ�������ư���������о�� "/tmp/tmp.txt" ��¸�ߤ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_at_first_submit1 called" �Ƚ񤫤�Ƥ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_at_first_submit2 called" �Ƚ񤫤�Ƥ��뤳��

  ################################################################################################################################################

  @manual
  ���ʥꥪ: [�۾��]���٥�ȼ����塢MQ�ץ����������󤷤��ݤ˥ե����륪���С�����(ack after_all)

    ���� VIP�����꤬zbtgnmq1������Ƥ��뤳��

    �⤷ "Tengine�����ץ���"�ε�ư��Ԥ������"tengined -T $dsl"�Ȥ������ޥ�ɤ�¹Ԥ���
    �⤷ "Tengine�����ץ���"��ɸ����Ϥ���PID���ǧ����
    �⤷ "Tengine�����ץ���"�ξ��֤�"��Ư��"�Ǥ��뤳�Ȥ��ǧ����

    # MQ����ߤ���Ƶ�ư

    �⤷ MQ�ץ�������ߤ��뤿��� zbtgnmq1�ˤ� "sudo rabbitmqctl stop"�Ȥ������ޥ�ɤ�¹Ԥ���
    �⤷ Pacemaker��MQ�ץ�����Ƶ�ư���Ƥ���Τ��ǧ���뤿��� "sudo rabbitmqctl status"�Ȥ������ޥ�ɤ�¹Ԥ���
    �ʤ�� '{running_applications,[{rabbit,"RabbitMQ",' �Ȥ������Ƥ�ޤ���Ϥ����뤳��

    # ���٥�ȼ¹�

    �⤷ ���٥��ȯ�в��̤���"event_after_all"��ȯ�Ф���

    �ʤ�� �����ץ�������ư���������о�� "/tmp/tmp.txt" ��¸�ߤ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_after_all1 called" �Ƚ񤫤�Ƥ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_after_all2 called" �Ƚ񤫤�Ƥ��뤳��


  @manual
  ���ʥꥪ: [�۾��]���٥�������塢MQ�����Ф������󤷤��ݤ˥ե����륪���С�����(ack after_all)

    ���� VIP�����꤬zbtgnmq1������Ƥ��뤳��

    �⤷ "Tengine�����ץ���"�ε�ư��Ԥ������"tengined -T $dsl"�Ȥ������ޥ�ɤ�¹Ԥ���
    �⤷ "Tengine�����ץ���"��ɸ����Ϥ���PID���ǧ����
    �⤷ "Tengine�����ץ���"�ξ��֤�"��Ư��"�Ǥ��뤳�Ȥ��ǧ����

    # MQ����ߤ���Ƶ�ư

    �⤷ zbtgnmq1�β��ۥޥ������Ȥ�
    �⤷ VIP���ڤ��ؤ�ä�zbtgnmq2����������Ȥ��ǧ���� # ping�Ȥ�

    # 2����

    �⤷ ���٥��ȯ�в��̤���"event_after_all"��ȯ�Ф���

    �ʤ�� �����ץ�������ư���������о�� "/tmp/tmp.txt" ��¸�ߤ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_after_all1 called" �Ƚ񤫤�Ƥ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_after_all2 called" �Ƚ񤫤�Ƥ��뤳��


  @manual
  ���ʥꥪ: [�۾��]���٥�ȼ����塢MQ�ץ����������󤷤��ݤ˥ե����륪���С�����(ack after_all)

    ���� VIP�����꤬zbtgnmq1������Ƥ��뤳��

    �⤷ "Tengine�����ץ���"�ε�ư��Ԥ������"tengined -T $dsl"�Ȥ������ޥ�ɤ�¹Ԥ���
    �⤷ "Tengine�����ץ���"��ɸ����Ϥ���PID���ǧ����
    �⤷ "Tengine�����ץ���"�ξ��֤�"��Ư��"�Ǥ��뤳�Ȥ��ǧ����

    # 1����

    �⤷ ���٥��ȯ�в��̤���"event_after_all"��ȯ�Ф���

    �ʤ�� �����ץ�������ư���������о�� "/tmp/tmp.txt" ��¸�ߤ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_after_all1 called" �Ƚ񤫤�Ƥ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_after_all2 called" �Ƚ񤫤�Ƥ��뤳��

    # MQ����ߤ���Ƶ�ư

    �⤷ MQ�ץ�������ߤ��뤿��� zbtgnmq1�ˤ� "sudo rabbitmqctl stop"�Ȥ������ޥ�ɤ�¹Ԥ���
    �⤷ Pacemaker��MQ�ץ�����Ƶ�ư���Ƥ���Τ��ǧ���뤿��� "sudo rabbitmqctl status"�Ȥ������ޥ�ɤ�¹Ԥ���
    �ʤ�� '{running_applications,[{rabbit,"RabbitMQ",' �Ȥ������Ƥ�ޤ���Ϥ����뤳��

    # 2����

    �⤷ ���������о��"/tmp/tmp.txt"��������
    ���� ���٥��ȯ�в��̤���"event_after_all"��ȯ�Ф���

    �ʤ�� �����ץ�������ư���������о�� "/tmp/tmp.txt" ��¸�ߤ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_after_all1 called" �Ƚ񤫤�Ƥ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_after_all2 called" �Ƚ񤫤�Ƥ��뤳��


  @manual
  ���ʥꥪ: [�۾��]���٥�������塢MQ�����Ф������󤷤��ݤ˥ե����륪���С�����(ack after_all)

    ���� VIP�����꤬zbtgnmq1������Ƥ��뤳��

    �⤷ "Tengine�����ץ���"�ε�ư��Ԥ������"tengined -T $dsl"�Ȥ������ޥ�ɤ�¹Ԥ���
    �⤷ "Tengine�����ץ���"��ɸ����Ϥ���PID���ǧ����
    �⤷ "Tengine�����ץ���"�ξ��֤�"��Ư��"�Ǥ��뤳�Ȥ��ǧ����

    # 1����

    �⤷ ���٥��ȯ�в��̤���"event_after_all"��ȯ�Ф���

    �ʤ�� �����ץ�������ư���������о�� "/tmp/tmp.txt" ��¸�ߤ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_after_all1 called" �Ƚ񤫤�Ƥ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_after_all2 called" �Ƚ񤫤�Ƥ��뤳��

    # MQ����ߤ���Ƶ�ư

    �⤷ zbtgnmq1�β��ۥޥ������Ȥ�
    �⤷ VIP���ڤ��ؤ�ä�zbtgnmq2����������Ȥ��ǧ���� # ping�Ȥ�

    # 2����

    �⤷ ���������о��"/tmp/tmp.txt"��������
    ���� ���٥��ȯ�в��̤���"event_after_all"��ȯ�Ф���

    �ʤ�� �����ץ�������ư���������о�� "/tmp/tmp.txt" ��¸�ߤ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_after_all1 called" �Ƚ񤫤�Ƥ��뤳��
    ���� "/tmp/tmp.txt" �򳫤��� "FileWritingDriver#event_after_all2 called" �Ƚ񤫤�Ƥ��뤳��


