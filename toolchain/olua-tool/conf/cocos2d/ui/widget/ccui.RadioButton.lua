local M = {}

local cls = class(M)
cls.CPPCLS = "cocos2d::ui::RadioButton::EventType"
cls.LUACLS = "ccui.RadioButton.EventType"
cls.enums [[
    SELECTED
    UNSELECTED
]]

local cls = class(M)
cls.CPPCLS = "cocos2d::ui::RadioButton"
cls.LUACLS = "ccui.RadioButton"
cls.SUPERCLS = "ccui.AbstractCheckButton"
cls.funcs [[
    static RadioButton* create()
    static RadioButton* create(const std::string& backGround, const std::string& backGroundSelected, const std::string& cross, const std::string& backGroundDisabled, const std::string& frontCrossDisabled, Widget::TextureResType texType = Widget::TextureResType::LOCAL)
    static RadioButton* create(const std::string& backGround, const std::string& cross, Widget::TextureResType texType = Widget::TextureResType::LOCAL)
]]

cls.callback(
    'void addEventListener(@nullable const std::function<void(RadioButton* radioButton, EventType)>& callback)',
    {
        CALLBACK_MAKER = 'olua_makecallbacktag("RadioButtonCallback")',
        CALLBACK_REPLACE = true,
        CALLBACK_MODE = 'OLUA_CALLBACK_TAG_ENDWITH',
    }
)

local cls = class(M)
cls.CPPCLS = "cocos2d::ui::RadioButtonGroup::EventType"
cls.LUACLS = "ccui.RadioButtonGroup.EventType"
cls.enums [[
    SELECT_CHANGED
]]

local cls = class(M)
cls.CPPCLS = "cocos2d::ui::RadioButtonGroup"
cls.LUACLS = "ccui.RadioButtonGroup"
cls.SUPERCLS = "ccui.Widget"
cls.funcs [[
    static RadioButtonGroup* create()
    int getSelectedButtonIndex()
    void setSelectedButton(int index)
    void setSelectedButton(RadioButton* radioButton)
    void setSelectedButtonWithoutEvent(int index)
    void setSelectedButtonWithoutEvent(RadioButton* radioButton)

    void addRadioButton(@ref(map radioButtons) RadioButton* radioButton)
    void removeRadioButton(@unref(map radioButtons) RadioButton* radioButton)
    @unref(all radioButtons) void removeAllRadioButtons()
    ssize_t getNumberOfRadioButtons()
    @ref(map radioButtons) RadioButton* getRadioButtonByIndex(int index)

    void setAllowedNoSelection(bool allowedNoSelection)
    bool isAllowedNoSelection()
]]
cls.props [[
    selectedButtonIndex
    numberOfRadioButtons
    allowedNoSelection
]]
cls.callback(
    'void addEventListener(@nullable const std::function<void(RadioButton* radioButton, int index, EventType)>& callback)',
    {
        CALLBACK_MAKER = 'olua_makecallbacktag("RadioButtonGroupCallback")',
        CALLBACK_REPLACE = true,
        CALLBACK_MODE = 'OLUA_CALLBACK_TAG_ENDWITH',
    }
)

return M