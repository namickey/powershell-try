#encoding: sjis
# �f�[�^����

b = open('before-large.csv', 'w')
b.write('�e�[�u��ID,�e�[�u����,�J������,�T�C�Y\n')

tablecount = 100
columncount = 50

for i in range(tablecount):
    for h in range(columncount):
        b.write(f'table-{i+1},�e�[�u��-{i+1},field-{h+1},{i+1}\n')

a = open('after-large.csv', 'w')
a.write('�e�[�u��ID,�e�[�u����,�J������,�T�C�Y\n')

for i in range(tablecount):
    for h in range(columncount):
        a.write(f'table-{i+1},�e�[�u��-{i+1},field-{h+1},{i+1}\n')
