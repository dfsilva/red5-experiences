package org.red5.core;

/*
 * RED5 Open Source Flash Server - http://www.osflash.org/red5
 * 
 * Copyright (c) 2006-2008 by respective authors (see below). All rights reserved.
 * 
 * This library is free software; you can redistribute it and/or modify it under the 
 * terms of the GNU Lesser General Public License as published by the Free Software 
 * Foundation; either version 2.1 of the License, or (at your option) any later 
 * version. 
 * 
 * This library is distributed in the hope that it will be useful, but WITHOUT ANY 
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A 
 * PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License along 
 * with this library; if not, write to the Free Software Foundation, Inc., 
 * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA 
 */

import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;

import org.red5.core.domain.User;
import org.red5.server.adapter.ApplicationAdapter;
import org.red5.server.api.IConnection;
import org.red5.server.api.scope.IScope;
import org.red5.server.api.service.IPendingServiceCall;
import org.red5.server.api.service.IPendingServiceCallback;
import org.red5.server.api.service.IServiceCapableConnection;
import org.red5.server.api.service.ServiceUtils;

/**
 * Sample application that uses the client manager.
 * 
 * @author The Red5 Project (red5@osflash.org)
 */
public class Application extends ApplicationAdapter implements
		IPendingServiceCallback {

	protected HashMap users = new HashMap();

	/** {@inheritDoc} */
	@Override
	public boolean connect(IConnection conn, IScope scope, Object[] params) {
		if (params.length != 1) {
			rejectClient("Sem permissão de acesso ao sistema!");
			return false;
		}
		String username = params[0].toString();
		String uid = conn.getClient().getId();
		IServiceCapableConnection service = (IServiceCapableConnection) conn;

		User user = new User(uid, username);
		users.put(uid, user);

		service.invoke("listaUsuarios", new Object[] { listaUsuarios() }, this);
		enviarNovosUsuarios();

		System.out.println("Novo usuario: " + uid);
		return true;
	}

	/** {@inheritDoc} */
	@Override
	public void disconnect(IConnection conn, IScope scope) {
		super.disconnect(conn, scope);
	}

	@Override
	public void resultReceived(IPendingServiceCall arg0) {
		System.out.println(arg0);
	}

	@Override
	public synchronized boolean start(IScope scope) {
		return super.start(scope);
	}

	protected void enviarNovosUsuarios() {
		Object[] params = new Object[] { listaUsuarios() };
		ServiceUtils.invokeOnAllConnections(scope, "listaUsuarios", params);
	}

	protected HashMap listaUsuarios() {
		HashMap params = new HashMap();
		Integer key = 0;
		Set s = users.keySet();
		for (Iterator it = s.iterator(); it.hasNext();) {
			User value = (User) users.get(it.next());
			if (value != null) {
				params.put(key, value);
				key++;
			}
		}
		return params;
	}

}
