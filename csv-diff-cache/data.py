#encoding: sjis
# データ生成

b = open('before-large.csv', 'w')
b.write('テーブルID,テーブル名,カラム名,サイズ\n')

tablecount = 100
columncount = 50

for i in range(tablecount):
    for h in range(columncount):
        b.write(f'table-{i+1},テーブル-{i+1},field-{h+1},{i+1}\n')

a = open('after-large.csv', 'w')
a.write('テーブルID,テーブル名,カラム名,サイズ\n')

for i in range(tablecount):
    for h in range(columncount):
        a.write(f'table-{i+1},テーブル-{i+1},field-{h+1},{i+1}\n')
