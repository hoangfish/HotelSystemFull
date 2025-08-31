#include "../inc/SocketMgr.h"

// Initialize static members
std::mutex SocketMgr::mtx;
SocketMgr *SocketMgr::instance = nullptr;

SocketMgr::SocketMgr(/* args */) {}

SocketMgr::~SocketMgr() {}