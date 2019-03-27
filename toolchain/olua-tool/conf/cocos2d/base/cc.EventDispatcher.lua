local cls = class()
cls.CPPCLS = "cocos2d::EventDispatcher"
cls.LUACLS = "cc.EventDispatcher"
cls.SUPERCLS = "cc.Ref"
cls.DEFCHUNK = [[
static void doRemoveEventListenersForTarget(lua_State *L, cocos2d::Node *target, bool recursive, const char *refname)
{
    if (olua_getobj(L, target)) {
        olua_unrefall(L, -1, refname);
        lua_pop(L, 1);
    }
    if (recursive) {
        const auto &children = target->getChildren();
        for (const auto& child : children)
        {
            doRemoveEventListenersForTarget(L, child, recursive, refname);
        }
    }
}]]
cls.funcs([[
    void addEventListenerWithSceneGraphPriority(EventListener* listener, Node* node)
    void addEventListenerWithFixedPriority(EventListener* listener, int fixedPriority)
    void removeCustomEventListeners(const std::string& customEventName)
    void removeEventListener(EventListener* listener)
    void removeEventListenersForType(EventListener::Type listenerType)
    void removeEventListenersForTarget(Node* target, bool recursive = false)
    void removeAllEventListeners()
    void pauseEventListenersForTarget(Node* target, bool recursive = false)
    void resumeEventListenersForTarget(Node* target, bool recursive = false)
    void setPriority(EventListener* listener, int fixedPriority)
    void setEnabled(bool isEnabled)
    bool isEnabled()
    void dispatchEvent(Event* event)
    void dispatchCustomEvent(const std::string &eventName, void *optionalUserData = nullptr)
    bool hasEventListener(const EventListener::ListenerID& listenerID)
]])
cls.props [[
    enabled
]]
cls.func('addCustomEventListener', [[
{
    lua_settop(L, 3);

    cocos2d::EventDispatcher *self = nullptr;
    std::string eventName;
    void *callback_store_obj = nullptr;

    olua_to_cppobj(L, 1, (void **)&self, "cc.EventDispatcher");
    olua_check_std_string(L, 2, &eventName);
    
    cocos2d::EventListenerCustom *listener = new cocos2d::EventListenerCustom();
    listener->autorelease();
    olua_push_cppobj<cocos2d::EventListenerCustom>(L, listener, "cc.EventListenerCustom");
    callback_store_obj = listener;
    std::string func = olua_setcallback(L, callback_store_obj, eventName.c_str(), 3, OLUA_CALLBACK_TAG_NEW);
    listener->init(eventName, [callback_store_obj, func](cocos2d::EventCustom *event) {
        lua_State *L = olua_mainthread();
        int top = lua_gettop(L);
        olua_push_cppobj<cocos2d::EventCustom>(L, event, "cc.EventCustom");
        olua_callback(L, callback_store_obj, func.c_str(), 1);

        // stack value
        olua_push_cppobj<cocos2d::EventCustom>(L, event, "cc.EventCustom");
        olua_callgc(L, -1, false);
        
        lua_settop(L, top);
    });
    
    // EventListenerCustom* EventDispatcher::addCustomEventListener(const std::string &eventName, const std::function<void(EventCustom*)>& callback)
    //  {
    //      EventListenerCustom *listener = EventListenerCustom::create(eventName, callback);
    //      addEventListenerWithFixedPriority(listener, 1);
    //      return listener;
    //  }
    self->addEventListenerWithFixedPriority(listener, 1);
    lua_pushvalue(L, 4);

    ${INJECT_AFTER}

    return 1;
}]])
cls.func('addEventListener', [[
{
    lua_settop(L, 2);
    cocos2d::EventDispatcher *self = (cocos2d::EventDispatcher *)olua_toobj(L, 1, "cc.EventDispatcher");
    cocos2d::EventListener *listener = (cocos2d::EventListener *)olua_checkobj(L, 2, "cc.EventListener");

    ${INJECT_BEFORE}

    self->addEventListenerWithFixedPriority(listener, 1);
    return 0;
}]])

--
-- ref
--
-- void addEventListenerWithSceneGraphPriority(EventListener* listener, Node* node)
-- EventListenerCustom* addCustomEventListener(const std::string &eventName, const std::function<void(EventCustom*)>& callback)
-- void addEventListenerWithFixedPriority(EventListener* listener, int fixedPriority)
cls.inject('addEventListenerWithSceneGraphPriority', mapref_arg_value('listeners', 3, 2))
cls.inject('addEventListenerWithFixedPriority', mapref_arg_value('listeners'))
cls.inject('addEventListener', mapref_arg_value('listeners'))
cls.inject('addCustomEventListener', mapref_return_value('listeners'))
-- void removeCustomEventListeners(const std::string& customEventName)
-- void removeEventListenersForType(EventListener::Type listenerType)
-- void removeEventListener(EventListener* listener)
cls.inject('removeEventListenersForTarget', {
    BEFORE = [[
        bool recursive = false;
        cocos2d::Node *node = (cocos2d::Node *)olua_checkobj(L, 2, "cc.Node");
        if (lua_gettop(L) >= 3) {
            recursive = olua_toboolean(L, 3);
        }
        doRemoveEventListenersForTarget(L, node, recursive, "listeners");
    ]]
})
cls.inject('removeCustomEventListeners', mapunef_by_compare('listeners'))
cls.inject('removeEventListenersForType', mapunef_by_compare('listeners'))
cls.inject('removeEventListener', mapunef_by_compare('listeners'))
cls.inject('removeAllEventListeners', mapunef_by_compare('listeners'))

return cls