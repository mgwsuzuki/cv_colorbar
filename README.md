# Arty Z7-20����J���[�o�[�M�����o�͂���

HDMI�M���̂��׋���ړI�ɁA�J���[�o�[���o�͂���RTL������Ă݂��B
Digilent����HDMI-out�̃��t�@�����X�����邯�ǁA���@�\�E���@�\�̂���
������ɂ��������̂ł����������Ă݂��B

���W�b�N�̍ŏ����ȂǍl���Ă��炸�A�������킩��₷���Ǝv���L�q�Ȃ̂ł������炸�B


# Vivado�v���W�F�N�g

Vivado�𗧂��グ�ATcl Console����colorbar_proj.tcl������t�H���_�Ɉړ�����B

cd /project/folder

colorbar_proj.tcl��ǂݍ���

source colorbar_proj.tcl

���Ƃ�Generate Bitstream�����s���AFPGA���R���t�B�O���[�V��������B

�ꕔ�^�C�~���O�ᔽ���ł邪�A325MHz�N���b�N��L�`�J�����邽�߂̃J�E���^�Ȃ̂łЂƂ܂���������B


# SDK

Zynq��FPGA���R���t�B�O���[�V�������Ă�PS�����R���t�B�O���[�V�������Ȃ���PL���������Ȃ��B
����RTL�̓\�t�g�E�F�A����̐ݒ��S�����Ȃ��̂ŁAXSDK�̃e���v���[�g�Ƃ��ėp�ӂ���Ă���
helloworld�����̂܂܎g���B�悤��ps7_init.tcl�����s�����΂���ł悢�B

�ꉞ�菇���ȉ��Ɏ����B

Vivado��File->Export->Export Hardware�����s����BInclude Btistream�Ƀ`�F�b�N�����Ď��s�B

!(export_hardware.png)

Vivado��File->Launch SDK�����s����B

!(launch_SDK.png)

XSDK����File->New->Application Project�����s����B
�X�N���[���V���b�g�̒ʂ�ɐݒ肷��B

!(new_appplication_project1.png)
!(new_appplication_project2.png)


XSDK����Run->Run Configuration�����s����B
���y�C����Xilinx C/C++ application (GDB)���E�N���b�N����New
�X�N���[���V���b�g�̒ʂ�ɐݒ肷��B

!(run_config1.png)
!(run_config2.png)

Run�������Ď��s����B
