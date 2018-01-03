cd $(dirname "$0")

cd ColorPalette
./attach_palette.sh
cd ..

cd Template
mkdir ~/Library/Developer/Xcode/Templates/File\ Templates/Boost 2>>/dev/null
cp -r *.xctemplate ~/Library/Developer/Xcode/Templates/File\ Templates/Boost/
cd ..