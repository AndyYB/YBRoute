
#工程名称
TARGET_NAME="YBRoute"
#本地路径
PROPATH=/Users/caoyanbin/Documents/GitHubCYB/
#proj库地址
GITHUBPATH=https://github.com/AndyYB/$TARGET_NAME.git
#spec地址
GITEESPEC=https://gitee.com/andycyb/YBRepoSpec.git
#Example路径
EXAMPLEPATH=${PROPATH}$TARGET_NAME/Example
echo "---repo---输入1创建 pod项目"
echo "---repo---输入2 git init/push master"
echo "---repo---输入3提交 验证 push sepc"
echo "---repo---输入4 pod -install Proj"

echo "------输入5 git add Push-------"
echo "------输入6 删除tag-------"

function podInstall() {
    echo "tips-pod install"
    
    cd ${EXAMPLEPATH}
    pod install
}

function gitaddPush() {
    echo "tips-gitaddPush"
    
    cd ${PROPATH}$TARGET_NAME
    git add .
    read -p "Please input your commit:" commit
    git commit -m "$commit"
    git push origin master
    
    read -p "Please input your tags-(eg:0.1.0):" TagName
    git tag -m "$TagName" $TagName
    git push --tags
}

function removetag() {
    echo "tips-removetag"
    
    cd ${PROPATH}$TARGET_NAME
    read -p "Please input your'll remove tags:" TagName
    git push origin :refs/tags/$TagName
}

function createPods() {
    echo "tips-创建pod项目"
    #1
    pod repo add $TARGET_NAME $GITEESPEC

    # pod repo remove $TARGET_NAME
    # cd ~/.cocoapods/repos

    cd ${PROPATH}
    pod lib create $TARGET_NAME
    podInstall
}

function libPushPods() {
    echo "tips-验证push项目"
    cd ${PROPATH}$TARGET_NAME/
    
#    pod spec lint --sources='私有仓库repo地址,https://github.com/CocoaPods/Specs'
#    pod repo push 本地repo名 podspec名   --sources='私有仓库repo地址,https://github.com/CocoaPods/Specs'
#    7.如果私有库添加了静态库或者dependency用了静态库
#    那么执行pod lib lint还有pod spec lint时候需要加上—user-libraries选项
    pod spec lint --sources=''${GITEESPEC}',https://github.com/CocoaPods/Specs' --allow-warnings
    pod repo push $TARGET_NAME $TARGET_NAME.podspec --sources=''$GITEESPEC',https://github.com/CocoaPods/Specs' --allow-warnings
    
#    pod lib lint $TARGET_NAME.podspec --allow-warnings
#    pod repo push $TARGET_NAME $TARGET_NAME.podspec --allow-warnings
}

function initGit() {
    echo "tips-创建git项目"
    cd ${PROPATH}$TARGET_NAME
    git init
    git add .
    git commit -m "create repo commit"
    git remote add origin $GITHUBPATH
    git push -u origin master

    read -p "Please input your tags-(eg:0.1.0):" TagName
    git tag -m "first tags $TagName" $TagName
    git push --tags
}

read -p "Please input your choice(1|2|3|4|5|6|7):" methodd
case $methodd in
        "1")
                createPods;
                echo "end-1-";
                ;;
        "2")
                initGit;
                echo "end-2-";
                ;;
        "3")
                libPushPods;
                echo "end-3-";
                ;;
        "4")
                podInstall;
                echo "end-4-";
                ;;
        "5")
                gitaddPush;
                echo "end-5-";
                ;;
        "6")
                removetag;
                echo "end-6-";
                ;;
esac

