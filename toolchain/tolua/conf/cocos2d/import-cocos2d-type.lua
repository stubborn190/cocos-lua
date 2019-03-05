local function make_luacls(cppname)
    cppname = string.gsub(cppname, "cocos2d::", "cc.")
    cppname = string.gsub(cppname, "[ *]*$", '')
    return cppname
end

REG_TYPE {
    TYPENAME = 'cocos2d::Data', 
    CONV_FUNC = "xluacv_$ACTION_ccdata",
}

REG_TYPE {
    TYPENAME = 'cocos2d::UserDefault *',
    CONV_FUNC = "tolua_$ACTION_obj",
    LUACLS = make_luacls,
}

REG_TYPE {
    TYPENAME = 'cocos2d::Vec2',
    CONV_FUNC = "xluacv_$ACTION_ccvec2",
    INIT_VALUE = false,
    VARS = 2,
}

REG_TYPE {
    TYPENAME = 'cocos2d::Vector',
    CONV_FUNC = "xluacv_$ACTION_ccvector",
    INIT_VALUE = false,
}

REG_TYPE {
    TYPENAME = table.concat({
        'cocos2d::Ref *',
        'cocos2d::Director *',
        'cocos2d::Scheduler *',
        'cocos2d::ActionManager *',
        'cocos2d::Node *',
        'cocos2d::Sprite *',
        'cocos2d::Scene *',
        'cocos2d::Action *',
    }, '|'),
    CONV_FUNC = "xluacv_$ACTION_ccobj",
    LUACLS = make_luacls,
}